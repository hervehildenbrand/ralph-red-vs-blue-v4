#!/bin/bash
# restore-baseline.sh - Restore all devices to baseline configuration
# Used between rounds to reset the lab to known-good state

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
BASELINE_DIR="$PROJECT_DIR/topology/configs/baseline"
REMOTE_HOST="labuser@<server-ip>"
LAB_NAME="red-vs-blue-v3"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}=== Baseline Restore Script ===${NC}"
echo "Project: $PROJECT_DIR"
echo "Baseline configs: $BASELINE_DIR"
echo ""

# List of cEOS devices to restore (not CEs - they're Alpine Linux)
DEVICES=("rr1" "rr2" "p1" "p2" "p3" "p4" "pe1" "pe2" "pe3" "pe4" "pe5" "pe6")

# Step 1: Copy baseline configs to remote server
echo -e "${YELLOW}Step 1: Copying baseline configs to remote server...${NC}"
ssh $REMOTE_HOST "mkdir -p /tmp/baseline-configs"
scp -q "$BASELINE_DIR"/*.cfg "$REMOTE_HOST:/tmp/baseline-configs/"
echo -e "${GREEN}Done.${NC}"
echo ""

# Step 2: Apply baseline configs to each device
echo -e "${YELLOW}Step 2: Applying baseline configs to devices...${NC}"
for device in "${DEVICES[@]}"; do
    echo -n "  Restoring $device... "

    # Check if device container exists
    if ! ssh $REMOTE_HOST "docker ps --format '{{.Names}}' | grep -q 'clab-${LAB_NAME}-${device}'" 2>/dev/null; then
        echo -e "${RED}SKIP (container not running)${NC}"
        continue
    fi

    # Copy config into container
    ssh $REMOTE_HOST "docker cp /tmp/baseline-configs/${device}.cfg clab-${LAB_NAME}-${device}:/tmp/baseline.cfg"

    # Apply config using configure replace (atomic operation)
    ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-${device} Cli -c 'configure replace flash:/tmp/baseline.cfg'" 2>/dev/null || \
    ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-${device} Cli -c 'copy file:/tmp/baseline.cfg startup-config'" 2>/dev/null

    echo -e "${GREEN}OK${NC}"
done
echo ""

# Step 3: Wait for convergence
echo -e "${YELLOW}Step 3: Waiting for protocol convergence (15 seconds)...${NC}"
sleep 15
echo -e "${GREEN}Done.${NC}"
echo ""

# Step 4: Verify connectivity
echo -e "${YELLOW}Step 4: Verifying VRF connectivity...${NC}"

echo -n "  VRF ALPHA (CE1 -> CE4): "
result=$(ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-ce1 ping -c 3 -W 2 192.168.4.2" 2>&1)
if echo "$result" | grep -q "0% packet loss"; then
    echo -e "${GREEN}PASS${NC}"
    ALPHA_PASS=1
else
    echo -e "${RED}FAIL${NC}"
    ALPHA_PASS=0
fi

echo -n "  VRF BETA (CE2 -> CE5):  "
result=$(ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-ce2 ping -c 3 -W 2 192.168.5.2" 2>&1)
if echo "$result" | grep -q "0% packet loss"; then
    echo -e "${GREEN}PASS${NC}"
    BETA_PASS=1
else
    echo -e "${RED}FAIL${NC}"
    BETA_PASS=0
fi

echo -n "  VRF GAMMA (CE3 -> CE6): "
result=$(ssh $REMOTE_HOST "docker exec clab-${LAB_NAME}-ce3 ping -c 3 -W 2 192.168.6.2" 2>&1)
if echo "$result" | grep -q "0% packet loss"; then
    echo -e "${GREEN}PASS${NC}"
    GAMMA_PASS=1
else
    echo -e "${RED}FAIL${NC}"
    GAMMA_PASS=0
fi

echo ""

# Final status
if [ "$ALPHA_PASS" -eq 1 ] && [ "$BETA_PASS" -eq 1 ] && [ "$GAMMA_PASS" -eq 1 ]; then
    echo -e "${GREEN}=== BASELINE RESTORED SUCCESSFULLY ===${NC}"
    exit 0
else
    echo -e "${RED}=== BASELINE RESTORE INCOMPLETE ===${NC}"
    echo "Some VRFs failed connectivity test. Manual intervention may be required."
    exit 1
fi
