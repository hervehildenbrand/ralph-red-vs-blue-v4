# Round 09 Summary

## Result: BLUE WINS

## Attack Details

| Attribute | Value |
|-----------|-------|
| **Attack ID** | TE-E5 - Next-Hop-Self on RR |
| **Target** | RR1 and RR2 (Route Reflectors) |
| **Difficulty** | Expert |
| **Impact** | ALL VRFs |

### Attack Applied

Added `next-hop-self` to RR's PE-CLIENTS peer group:
```
router bgp 65000
  neighbor PE-CLIENTS next-hop-self
```

This causes RR to change BGP next-hop to itself, but VPN labels still reference originating PE, creating black-hole.

## Diagnosis Timeline

| Event | Timestamp | Duration |
|-------|-----------|----------|
| RALPH-Red Start | 08:25:57 | - |
| Attack Complete | 08:28:12 | ~2 min |
| RALPH-Blue Start | 08:30:01 | - |
| Fix Complete | 08:33:17 | ~3 min |

**Total Blue Diagnosis Time**: ~3 minutes

## Blue Diagnosis Summary

RALPH-Blue correctly identified the root cause:
- `next-hop-self` on Route Reflectors is fundamentally wrong for MPLS VPN
- RRs should preserve original next-hop (the originating PE)
- With next-hop-self, traffic was sent to RR which has no VRF/label mapping

### Fix Applied
```
! On both RR1 and RR2:
router bgp 65000
  no neighbor PE-CLIENTS next-hop-self
```

## Impact Assessment

| VRF | Baseline | Post-Attack | Post-Fix |
|-----|----------|-------------|----------|
| ALPHA | 0% loss | **100% loss** | 0% loss |
| BETA | 0% loss | **100% loss** | 0% loss |
| GAMMA | 0% loss | **100% loss** | 0% loss |

## Scoring

### Red Points
| Achievement | Points | Earned |
|-------------|--------|--------|
| Multi-component attack | +10 | +10 (both RRs) |
| Diagnosis >5 min | +10 | - |
| GAIT compliance | +5 | +5 |
| **Red Total** | | **15** |

### Blue Points
| Achievement | Points | Earned |
|-------------|--------|--------|
| Correct diagnosis first try | +30 | +30 |
| Fix in <3 minutes | +20 | - |
| Fix in 3-5 minutes | +15 | +15 |
| Root cause fix | +20 | +20 |
| GAIT compliance | +5 | +5 |
| **Blue Total** | | **70** |

## Round Winner: BLUE (+55 point margin)
