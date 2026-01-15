#!/bin/bash
# run-round.sh - Orchestrate a single round of Red vs Blue
# Usage: ./run-round.sh <round-number>
#
# This script acts as the Referee:
# 1. Restores baseline
# 2. Sets up RALPH-Red PROMPT.md
# 3. Runs RALPH-Red (autonomous attack)
# 4. Captures post-attack evidence
# 5. Sets up RALPH-Blue PROMPT.md (NOC ticket)
# 6. Runs RALPH-Blue (autonomous diagnosis)
# 7. Captures post-fix evidence
# 8. Scores the round

set -e

ROUND=$1

if [ -z "$ROUND" ]; then
    echo "Usage: $0 <round-number>"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ROUND_NUM=$(printf '%02d' $ROUND)
ROUND_DIR="$PROJECT_DIR/rounds/round-${ROUND_NUM}"
RALPH_RED_DIR="$PROJECT_DIR/ralph-red"
RALPH_BLUE_DIR="$PROJECT_DIR/ralph-blue"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo ""
echo -e "${YELLOW}╔════════════════════════════════════════════════════════════╗${NC}"
echo -e "${YELLOW}║            RALPH RED VS BLUE - ROUND $ROUND_NUM                    ║${NC}"
echo -e "${YELLOW}╚════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Create round directory
mkdir -p "$ROUND_DIR/evidence"

#############################################
# PHASE 1: Restore Baseline
#############################################
echo -e "${BLUE}=== PHASE 1: Restoring Baseline ===${NC}"
"$SCRIPT_DIR/restore-baseline.sh"
if [ $? -ne 0 ]; then
    echo -e "${RED}ERROR: Baseline restore failed. Aborting round.${NC}"
    exit 1
fi

# Capture baseline evidence
"$SCRIPT_DIR/capture-evidence.sh" $ROUND baseline

#############################################
# PHASE 2: Setup RALPH-Red
#############################################
echo ""
echo -e "${RED}=== PHASE 2: Setting up RALPH-Red ===${NC}"

# Check if round attack file exists
ATTACK_SPEC="$ROUND_DIR/red-attack-spec.md"
if [ ! -f "$ATTACK_SPEC" ]; then
    echo -e "${YELLOW}WARNING: No attack spec found at $ATTACK_SPEC${NC}"
    echo "Creating from expert-catalog.json..."
    # You would generate this from expert-catalog.json
    echo "Please create $ATTACK_SPEC manually for now."
    exit 1
fi

# Copy attack spec to RALPH-Red PROMPT.md
cp "$ATTACK_SPEC" "$RALPH_RED_DIR/PROMPT.md"
echo "Attack specification loaded into ralph-red/PROMPT.md"

#############################################
# PHASE 3: Run RALPH-Red
#############################################
echo ""
echo -e "${RED}=== PHASE 3: Running RALPH-Red (Autonomous Attack) ===${NC}"
echo "Starting RALPH in ralph-red directory..."
echo "Command: cd $RALPH_RED_DIR && ralph --monitor --timeout 10"
echo ""
echo -e "${YELLOW}>>> Press Enter to start RALPH-Red, or Ctrl+C to abort${NC}"
read

cd "$RALPH_RED_DIR"
ralph --monitor --timeout 10 || true
cd "$PROJECT_DIR"

# Capture post-attack evidence
echo ""
echo -e "${RED}=== Capturing post-attack evidence ===${NC}"
"$SCRIPT_DIR/capture-evidence.sh" $ROUND post-attack

# Copy RALPH-Red execution log
if [ -f "$RALPH_RED_DIR/ralph.log" ]; then
    cp "$RALPH_RED_DIR/ralph.log" "$ROUND_DIR/red-attack.log"
fi

#############################################
# PHASE 4: Verify Attack Success
#############################################
echo ""
echo -e "${RED}=== PHASE 4: Verifying Attack Success ===${NC}"
echo "Checking which VRF(s) are broken..."
# Read from post-attack connectivity.txt
cat "$ROUND_DIR/evidence/post-attack-state/connectivity.txt" | grep -E "(ALPHA|BETA|GAMMA|packet loss)"

#############################################
# PHASE 5: Setup RALPH-Blue
#############################################
echo ""
echo -e "${BLUE}=== PHASE 5: Setting up RALPH-Blue ===${NC}"

# Check if NOC ticket exists
NOC_TICKET="$ROUND_DIR/noc-ticket.md"
if [ ! -f "$NOC_TICKET" ]; then
    echo -e "${YELLOW}WARNING: No NOC ticket found at $NOC_TICKET${NC}"
    echo "Please create the NOC ticket manually."
    exit 1
fi

# Copy NOC ticket to RALPH-Blue PROMPT.md
cp "$NOC_TICKET" "$RALPH_BLUE_DIR/PROMPT.md"
echo "NOC ticket loaded into ralph-blue/PROMPT.md"

#############################################
# PHASE 6: Run RALPH-Blue
#############################################
echo ""
echo -e "${BLUE}=== PHASE 6: Running RALPH-Blue (Autonomous Diagnosis) ===${NC}"
echo "Starting RALPH in ralph-blue directory..."
echo "Command: cd $RALPH_BLUE_DIR && ralph --monitor --timeout 15"
echo ""
echo -e "${YELLOW}>>> Press Enter to start RALPH-Blue, or Ctrl+C to abort${NC}"
read

cd "$RALPH_BLUE_DIR"
ralph --monitor --timeout 15 || true
cd "$PROJECT_DIR"

# Capture post-fix evidence
echo ""
echo -e "${BLUE}=== Capturing post-fix evidence ===${NC}"
"$SCRIPT_DIR/capture-evidence.sh" $ROUND post-fix

# Copy RALPH-Blue execution log
if [ -f "$RALPH_BLUE_DIR/ralph.log" ]; then
    cp "$RALPH_BLUE_DIR/ralph.log" "$ROUND_DIR/blue-diagnosis.log"
fi

#############################################
# PHASE 7: Score Round
#############################################
echo ""
echo -e "${GREEN}=== PHASE 7: Scoring Round ===${NC}"
echo "Checking final connectivity..."
cat "$ROUND_DIR/evidence/post-fix-state/connectivity.txt" | grep -E "(ALPHA|BETA|GAMMA|packet loss)"

# Determine winner
ALPHA_OK=$(grep -A5 "ALPHA" "$ROUND_DIR/evidence/post-fix-state/connectivity.txt" | grep -c "0% packet loss" || true)
BETA_OK=$(grep -A5 "BETA" "$ROUND_DIR/evidence/post-fix-state/connectivity.txt" | grep -c "0% packet loss" || true)
GAMMA_OK=$(grep -A5 "GAMMA" "$ROUND_DIR/evidence/post-fix-state/connectivity.txt" | grep -c "0% packet loss" || true)

echo ""
if [ "$ALPHA_OK" -ge 1 ] && [ "$BETA_OK" -ge 1 ] && [ "$GAMMA_OK" -ge 1 ]; then
    echo -e "${BLUE}╔════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║         BLUE WINS ROUND $ROUND_NUM!            ║${NC}"
    echo -e "${BLUE}╚════════════════════════════════════════╝${NC}"
    WINNER="BLUE"
else
    echo -e "${RED}╔════════════════════════════════════════╗${NC}"
    echo -e "${RED}║          RED WINS ROUND $ROUND_NUM!            ║${NC}"
    echo -e "${RED}╚════════════════════════════════════════╝${NC}"
    WINNER="RED"
fi

# Create round summary
cat > "$ROUND_DIR/summary.md" << EOF
# Round $ROUND_NUM Summary

## Result: $WINNER WINS

## Timeline

| Phase | Status |
|-------|--------|
| Baseline Restore | Complete |
| Red Attack | Complete |
| Blue Diagnosis | Complete |

## Final Connectivity

| VRF | Status |
|-----|--------|
| ALPHA | $( [ "$ALPHA_OK" -ge 1 ] && echo "PASS" || echo "FAIL" ) |
| BETA | $( [ "$BETA_OK" -ge 1 ] && echo "PASS" || echo "FAIL" ) |
| GAMMA | $( [ "$GAMMA_OK" -ge 1 ] && echo "PASS" || echo "FAIL" ) |

## Evidence Files

- evidence/baseline-state/
- evidence/post-attack-state/
- evidence/post-fix-state/
- red-attack.log
- blue-diagnosis.log
EOF

echo ""
echo -e "${GREEN}Round $ROUND_NUM complete. Summary: $ROUND_DIR/summary.md${NC}"
