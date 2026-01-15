# Round 12 Summary

## Attack: MIS-E3 - Metric Maze (Misdirection)

### Attack Details
- **Target**: P1, P2, P3 core routers
- **Decoys**: P1 Et1 (metric 50), P2 Et2 (metric 50)
- **Real Issue**: P3 Et3 (metric 16777214 - max)
- **Impact**: Suboptimal routing (no connectivity break)

### Red Team
- Applied 3 metric changes to confuse diagnosis
- Only P3 Et3 max-metric was truly problematic
- Attack created suboptimal paths but didn't break connectivity

### Blue Team
- Investigated all metric anomalies
- Correctly identified P3 Et3 as the real problem
- Applied targeted fix only (didn't blindly fix decoys)
- Left decoy metrics in place as "possibly intentional"

### Result: **BLUE WINS** (Excellent diagnosis)
Blue demonstrated expert-level diagnosis by identifying the real issue among decoys.

### Scoring
| Category | Points |
|----------|--------|
| Blue: Root cause identification | +30 |
| Blue: Targeted fix (avoided decoys) | +20 |
| Blue: Correct diagnosis first try | +30 |
| Red: Misdirection attempted | +5 |
| Red: Attack didn't fully break service | 0 |
