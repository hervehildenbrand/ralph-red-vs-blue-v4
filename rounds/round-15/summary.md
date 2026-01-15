# Round 15 Summary - FINAL BOSS

## Attack: ML-E4 - RR Policy Corruption + Decoy (ULTIMATE)

### Attack Details
- **Target**: PE5 (real issue) + PE6 (decoy)
- **PE5 Action**: Silent route rejection via inbound route-map on RR neighbors
- **PE6 Action**: ISIS metric 999 to create alarm noise
- **Impact**: BETA VRF 100% packet loss with misdirection

### Red Team Strategy
1. Created deny-only route-map RR-BLOCK-IN on PE5
2. Applied to both RR neighbors (10.0.0.1, 10.0.0.2)
3. BGP sessions remain UP (deceptive - looks healthy)
4. Routes silently rejected with "PolicyReject" status
5. PE6 decoy metric generates visible alarms

### Blue Team Investigation
1. Verified BETA VRF broken, ALPHA/GAMMA working
2. DID NOT get distracted by PE6 ISIS alarms (correctly identified as red herring)
3. Checked BGP VPN routes in detail on PE5
4. Found "PolicyReject" status indicating policy filtering
5. Identified route-map RR-BLOCK-IN applied inbound
6. Removed malicious route-map from PE5
7. All VRFs restored

### Result: **BLUE WINS - FINAL BOSS DEFEATED!**
Blue demonstrated exceptional diagnostic skills by:
- Ignoring the obvious PE6 decoy
- Investigating deeper into BGP policy
- Finding silent policy rejection

### Scoring
| Category | Points |
|----------|--------|
| Blue: Avoided decoy misdirection | +20 |
| Blue: Found silent policy rejection | +30 |
| Blue: Root cause fix | +20 |
| Red: Multi-layer attack | +10 |
| Red: Misdirection attempted | +10 |
