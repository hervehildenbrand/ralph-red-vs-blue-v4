# NOC-V4-009 Fix - 2026-01-15T07:33:01Z

## Root Cause
**Route Reflectors (RR1, RR2) had 'next-hop-self' configured**

This is incorrect for RRs because:
1. RRs should preserve the original PE's next-hop address
2. With next-hop-self, RR sets itself as next-hop
3. RRs are NOT in the data path - traffic goes PE-to-PE via MPLS
4. Result: Traffic tries to reach RR instead of remote PE = black-hole

## Configuration Error
```
router bgp 65000
  neighbor PE-CLIENTS next-hop-self  <- WRONG for RR!
```

## Fix Applied (both RR1 and RR2)
```
configure
router bgp 65000
  no neighbor PE-CLIENTS next-hop-self
end
```

## Impact
After fix, routes now have correct next-hop (originating PE):
- Before: next-hop = 10.0.0.1 (RR) - WRONG
- After: next-hop = 10.0.0.24 (PE4) - CORRECT

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
