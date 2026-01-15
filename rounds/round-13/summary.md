# Round 13 Summary

## Attack: SR-E6 - Anycast SID Conflict

### Attack Details
- **Target**: PE1 and PE2
- **Action**: Created duplicate Loopback1 (10.255.255.1/32) with SID index 100
- **Impact**: Silent forwarding issues (traffic randomly distributed)

### Red Team
- Created identical anycast loopback on PE1 and PE2
- Both advertising same prefix with same SID (900100)
- Attack didn't break connectivity but created ambiguous forwarding

### Blue Team
- Investigated SR-MPLS configuration
- Found duplicate anycast address and SID conflict
- Removed conflicting Loopback1 from PE2
- Verified all VRFs operational

### Result: **BLUE WINS**
Blue correctly identified and removed the SID conflict even though service wasn't broken.

### Scoring
| Category | Points |
|----------|--------|
| Blue: Root cause identification | +30 |
| Blue: Correct fix | +20 |
| Red: Silent attack (no outage) | +5 |
