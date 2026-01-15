# Round 14 Summary

## Attack: VRF-E4 - VRF Import Filter Removal

### Attack Details
- **Target**: PE5 BETA VRF
- **Action**: Removed route-target import vpn-ipv4 65000:200
- **Impact**: BETA VRF 100% packet loss (no remote routes)

### Red Team
- Removed RT import from PE5 BETA VRF configuration
- PE5 stopped importing BETA routes from PE2
- BETA connectivity completely broken

### Blue Team
- Identified missing RT import on PE5 BETA VRF
- Added back route-target import vpn-ipv4 65000:200
- Verified all VRFs restored

### Result: **BLUE WINS**
Blue correctly identified and fixed the missing RT import.

### Scoring
| Category | Points |
|----------|--------|
| Blue: Root cause identification | +30 |
| Blue: Correct fix | +20 |
| Red: Broke single VRF | +10 |
