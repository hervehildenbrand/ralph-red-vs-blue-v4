# Round 08 Summary

## Result: BLUE WINS

## Attack Details

| Attribute | Value |
|-----------|-------|
| **Attack ID** | ML-E5 - Cross-VRF Route Leak |
| **Target** | PE1 (ALPHA VRF) |
| **Difficulty** | Expert |
| **Attack Type** | Route Target Manipulation |

### Attack Applied

Added RT 65000:200 (BETA's RT) to ALPHA's export list:
```
vrf instance ALPHA
  route-target export vpn-ipv4 65000:200
```

## Diagnosis Timeline

| Event | Timestamp | Duration |
|-------|-----------|----------|
| RALPH-Red Start | 08:18:16 | - |
| Attack Complete | 08:19:22 | ~1 min |
| RALPH-Blue Start | 08:20:26 | - |
| Fix Complete | 08:22:31 | ~2 min |

**Total Blue Diagnosis Time**: ~2 minutes

## Blue Diagnosis Summary

RALPH-Blue correctly identified the root cause:
- Extra RT export 65000:200 on PE1 VRF ALPHA
- Caused ALPHA routes (192.168.1.0/24) to leak into BETA VRF

### Fix Applied
```
router bgp 65000
  vrf ALPHA
    no route-target export vpn-ipv4 65000:200
```

## Impact Assessment

| VRF | Baseline | Post-Attack | Post-Fix |
|-----|----------|-------------|----------|
| ALPHA | 0% loss | 0% loss | 0% loss |
| BETA | 0% loss | 0% loss (but route leaked) | 0% loss |
| GAMMA | 0% loss | 0% loss | 0% loss |

Note: Attack created route leak but didn't break connectivity.

## Scoring

### Red Points
| Achievement | Points | Earned |
|-------------|--------|--------|
| Multi-component attack | +10 | - |
| Diagnosis >5 min | +10 | - |
| GAIT compliance | +5 | +5 |
| **Red Total** | | **5** |

### Blue Points
| Achievement | Points | Earned |
|-------------|--------|--------|
| Correct diagnosis first try | +30 | +30 |
| Fix in <3 minutes | +20 | +20 |
| Root cause fix | +20 | +20 |
| GAIT compliance | +5 | +5 |
| **Blue Total** | | **75** |

## Round Winner: BLUE (+70 point margin)
