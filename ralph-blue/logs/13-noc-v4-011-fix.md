# NOC-V4-011 Fix - 2026-01-15T07:49:17Z

## Root Cause
**Asymmetric ISIS metrics on P1 and P3 links to P2**

| Device | Interface | Peer | Metric (Before) | Metric (After) |
|--------|-----------|------|-----------------|----------------|
| P1 | Ethernet2 | P2 | 100 | 10 |
| P3 | Ethernet2 | P2 | 100 | 10 |
| P2 | Ethernet2 | P1 | 10 | 10 |
| P2 | Ethernet3 | P3 | 10 | 10 |

The asymmetric metrics caused:
- Suboptimal path selection depending on traffic direction
- Potential route flapping as SPF recalculates
- Inconsistent latency and path behavior

## Fix Applied
```
! P1
configure
interface Ethernet2
  isis metric 10
end

! P3
configure
interface Ethernet2
  isis metric 10
end
```

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
