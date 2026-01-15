# NOC-V4-010 Fix - 2026-01-15T07:40:50Z

## Root Cause
**Broken route-map 'CE1-IN-BROKEN' applied to redistribute in address-family**

PE1 VRF ALPHA had:
```
router bgp 65000
  vrf ALPHA
    redistribute connected route-map CONNECTED-TO-BGP  <- Good
    address-family ipv4
      redistribute connected route-map CE1-IN-BROKEN   <- BROKEN
```

The route-map CE1-IN-BROKEN had inverted logic:
```
route-map CE1-IN-BROKEN deny 10     <- DENY if matches
  match ip address prefix-list CE1-ALLOWED
route-map CE1-IN-BROKEN permit 20   <- PERMIT everything else
```

This denied 192.168.1.0/24 (CE1 prefix) instead of permitting it.

## Fix Applied
```
configure
router bgp 65000
  vrf ALPHA
    address-family ipv4
      no redistribute connected route-map CE1-IN-BROKEN
end
```

The VRF-level redistribute with CONNECTED-TO-BGP handles the redistribution correctly.

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
