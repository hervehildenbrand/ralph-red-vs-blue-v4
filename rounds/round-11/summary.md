# Round 11 Summary

## Attack: INT-E6 - ISIS Metric Oscillation

### Attack Details
- **Target**: P1 and P3 core routers
- **Action**: Changed ISIS metric to 100 on Ethernet2 interfaces
- **Impact**: Suboptimal routing (no actual connectivity break)

### Red Team
- Applied isis metric 100 on P1 Ethernet2 (P1→P2 link)
- Applied isis metric 100 on P3 Ethernet2 (P3→P2 link)
- Attack executed successfully but didn't break connectivity

### Blue Team
- Identified asymmetric ISIS metrics on P1 and P3
- Restored metrics to default (10)
- Verified all VRFs operational

### Result: **BLUE WINS**
Blue correctly identified and fixed the ISIS metric anomalies even though connectivity wasn't actually broken.

### Scoring
| Category | Points |
|----------|--------|
| Blue: Root cause fix | +20 |
| Blue: Correct diagnosis | +30 |
| Blue: Minimal commands | +10 |
| Red: Attack didn't break connectivity | 0 |
