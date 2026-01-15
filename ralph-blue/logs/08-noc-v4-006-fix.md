# NOC-V4-006 Fix - 2026-01-15T06:39:50Z

## Root Cause
**VRF ALPHA import RT misconfiguration on PE1**

PE1 was configured to import RT 65000:999 instead of 65000:100:
```
router bgp 65000
  vrf ALPHA
    route-target import vpn-ipv4 65000:999  <- WRONG
```

Routes from PE4 with RT 65000:100 were in the VPNv4 table but not imported into the VRF.

## Fix Applied
```
configure
router bgp 65000
  vrf ALPHA
    no route-target import vpn-ipv4 65000:999
    route-target import vpn-ipv4 65000:100
end
```

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
