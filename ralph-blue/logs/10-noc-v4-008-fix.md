# NOC-V4-008 Fix - 2026-01-15T07:22:18Z

## Root Cause
**Cross-VRF route leak** - PE1 VRF ALPHA was exporting routes with BETA's RT.

PE1 had extra export RT configured:
```
router bgp 65000
  vrf ALPHA
    route-target export vpn-ipv4 65000:100  <- Correct (ALPHA)
    route-target export vpn-ipv4 65000:200  <- WRONG (BETA's RT!)
```

This caused ALPHA routes (192.168.1.0/24) to leak into VRF BETA.

## Security Impact
BETA customer could see and potentially access ALPHA customer networks - VRF isolation breach.

## Fix Applied
```
configure
router bgp 65000
  vrf ALPHA
    no route-target export vpn-ipv4 65000:200
end
```

## Verification
- Route leak removed (192.168.1.0/24 no longer in BETA)
- VRF isolation restored

| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
