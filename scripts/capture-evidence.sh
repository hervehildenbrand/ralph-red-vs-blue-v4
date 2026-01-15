#!/bin/bash
# capture-evidence.sh - Capture network state evidence for a round
# Usage: ./capture-evidence.sh <round-number> <phase>
# Phases: baseline | post-attack | post-fix

set -e

ROUND=$1
PHASE=$2

if [ -z "$ROUND" ] || [ -z "$PHASE" ]; then
    echo "Usage: $0 <round-number> <phase>"
    echo "Phases: baseline | post-attack | post-fix"
    exit 1
fi

# Validate phase
if [[ ! "$PHASE" =~ ^(baseline|post-attack|post-fix)$ ]]; then
    echo "Error: Invalid phase '$PHASE'"
    echo "Valid phases: baseline, post-attack, post-fix"
    exit 1
fi

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
ROUND_DIR="$PROJECT_DIR/rounds/round-$(printf '%02d' $ROUND)"
EVIDENCE_DIR="$ROUND_DIR/evidence/${PHASE}-state"
REMOTE_HOST="hhildenbrand@192.168.1.12"
LAB_NAME="red-vs-blue-v3"
TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}=== Evidence Capture ===${NC}"
echo "Round: $ROUND"
echo "Phase: $PHASE"
echo "Timestamp: $TIMESTAMP"
echo ""

# Create evidence directory
mkdir -p "$EVIDENCE_DIR"

# Capture connectivity tests
echo -e "${YELLOW}Capturing VRF connectivity tests...${NC}"
cat > "$EVIDENCE_DIR/connectivity.txt" << EOF
# VRF Connectivity Test - Round $ROUND - $PHASE
# Timestamp: $TIMESTAMP

=== VRF ALPHA (CE1 -> CE4) ===
EOF
ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-ce1 ping -c 3 192.168.4.2" 2>&1 >> "$EVIDENCE_DIR/connectivity.txt" || true

cat >> "$EVIDENCE_DIR/connectivity.txt" << EOF

=== VRF BETA (CE2 -> CE5) ===
EOF
ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-ce2 ping -c 3 192.168.5.2" 2>&1 >> "$EVIDENCE_DIR/connectivity.txt" || true

cat >> "$EVIDENCE_DIR/connectivity.txt" << EOF

=== VRF GAMMA (CE3 -> CE6) ===
EOF
ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-ce3 ping -c 3 192.168.6.2" 2>&1 >> "$EVIDENCE_DIR/connectivity.txt" || true

echo -e "${GREEN}Saved: connectivity.txt${NC}"

# Capture ISIS adjacencies from PE routers
echo -e "${YELLOW}Capturing ISIS adjacencies...${NC}"
cat > "$EVIDENCE_DIR/isis-adjacencies.txt" << EOF
# ISIS Adjacencies - Round $ROUND - $PHASE
# Timestamp: $TIMESTAMP
EOF

for pe in pe1 pe2 pe3 pe4 pe5 pe6; do
    echo "" >> "$EVIDENCE_DIR/isis-adjacencies.txt"
    echo "=== $pe ===" >> "$EVIDENCE_DIR/isis-adjacencies.txt"
    ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-${pe} Cli -c 'show isis neighbors'" 2>&1 >> "$EVIDENCE_DIR/isis-adjacencies.txt" || true
done
echo -e "${GREEN}Saved: isis-adjacencies.txt${NC}"

# Capture BGP summary
echo -e "${YELLOW}Capturing BGP summary...${NC}"
cat > "$EVIDENCE_DIR/bgp-summary.txt" << EOF
# BGP Summary - Round $ROUND - $PHASE
# Timestamp: $TIMESTAMP
EOF

for pe in pe1 pe2 pe3 pe4 pe5 pe6; do
    echo "" >> "$EVIDENCE_DIR/bgp-summary.txt"
    echo "=== $pe ===" >> "$EVIDENCE_DIR/bgp-summary.txt"
    ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-${pe} Cli -c 'show bgp summary'" 2>&1 >> "$EVIDENCE_DIR/bgp-summary.txt" || true
done
echo -e "${GREEN}Saved: bgp-summary.txt${NC}"

# Capture MPLS labels
echo -e "${YELLOW}Capturing MPLS LFIB...${NC}"
cat > "$EVIDENCE_DIR/mpls-lfib.txt" << EOF
# MPLS LFIB - Round $ROUND - $PHASE
# Timestamp: $TIMESTAMP
EOF

for pe in pe1 pe2 pe3 pe4 pe5 pe6; do
    echo "" >> "$EVIDENCE_DIR/mpls-lfib.txt"
    echo "=== $pe ===" >> "$EVIDENCE_DIR/mpls-lfib.txt"
    ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-${pe} Cli -c 'show mpls lfib'" 2>&1 >> "$EVIDENCE_DIR/mpls-lfib.txt" || true
done
echo -e "${GREEN}Saved: mpls-lfib.txt${NC}"

# Capture VRF routing tables for affected VRF (based on phase)
echo -e "${YELLOW}Capturing VRF routing tables...${NC}"
cat > "$EVIDENCE_DIR/vrf-routes.txt" << EOF
# VRF Routing Tables - Round $ROUND - $PHASE
# Timestamp: $TIMESTAMP
EOF

for pe in pe1 pe2 pe3 pe4 pe5 pe6; do
    echo "" >> "$EVIDENCE_DIR/vrf-routes.txt"
    echo "=== $pe ===" >> "$EVIDENCE_DIR/vrf-routes.txt"
    # Get VRF names and routes
    ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-${pe} Cli -c 'show vrf'" 2>&1 >> "$EVIDENCE_DIR/vrf-routes.txt" || true
    ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-${pe} Cli -c 'show ip route vrf all'" 2>&1 >> "$EVIDENCE_DIR/vrf-routes.txt" || true
done
echo -e "${GREEN}Saved: vrf-routes.txt${NC}"

# Copy RALPH agent logs if they exist
if [ "$PHASE" == "post-attack" ] && [ -d "$PROJECT_DIR/ralph-red/logs" ]; then
    echo -e "${YELLOW}Copying RALPH-Red logs...${NC}"
    cp -r "$PROJECT_DIR/ralph-red/logs/"* "$EVIDENCE_DIR/" 2>/dev/null || true
fi

if [ "$PHASE" == "post-fix" ] && [ -d "$PROJECT_DIR/ralph-blue/logs" ]; then
    echo -e "${YELLOW}Copying RALPH-Blue logs...${NC}"
    cp -r "$PROJECT_DIR/ralph-blue/logs/"* "$EVIDENCE_DIR/" 2>/dev/null || true
fi

# Create summary file
echo -e "${YELLOW}Creating evidence summary...${NC}"
cat > "$EVIDENCE_DIR/SUMMARY.md" << EOF
# Evidence Summary

- **Round**: $ROUND
- **Phase**: $PHASE
- **Captured**: $TIMESTAMP

## Files

| File | Description |
|------|-------------|
| connectivity.txt | VRF ping tests (CE to CE) |
| isis-adjacencies.txt | ISIS neighbor state on all PEs |
| bgp-summary.txt | BGP session state on all PEs |
| mpls-lfib.txt | MPLS label forwarding tables |
| vrf-routes.txt | VRF routing tables |

## Quick Analysis

\`\`\`
$(grep -E "(ALPHA|BETA|GAMMA|packet loss)" "$EVIDENCE_DIR/connectivity.txt" | head -20)
\`\`\`
EOF
echo -e "${GREEN}Saved: SUMMARY.md${NC}"

echo ""
echo -e "${GREEN}=== Evidence captured: $EVIDENCE_DIR ===${NC}"
ls -la "$EVIDENCE_DIR"
