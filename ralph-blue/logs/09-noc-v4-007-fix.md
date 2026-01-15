# NOC-V4-007 Fix - 2026-01-15T06:45:43Z

## Root Cause
**VRF BETA export RT misconfiguration on PE5**

PE5 was exporting routes with RT 65000:555 instead of 65000:200:
```
router bgp 65000
  vrf BETA
    route-target export vpn-ipv4 65000:555  <- WRONG
```

Routes were in PE2's VPNv4 table but not imported (PE2 imports RT 65000:200).

## Fix Applied
```
configure
router bgp 65000
  vrf BETA
    no route-target export vpn-ipv4 65000:555
    route-target export vpn-ipv4 65000:200
end
```

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
