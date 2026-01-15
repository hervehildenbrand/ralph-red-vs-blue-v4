# NOC-V4-005 Fix - 2026-01-15T06:31:56Z

## Root Cause
**Route-Target export mismatch** on edge PEs (PE1, PE2, PE3).

| VRF | PE | Wrong RT | Correct RT |
|-----|-----|----------|------------|
| ALPHA | PE1 | 65000:999 | 65000:100 |
| BETA | PE2 | 65000:777 | 65000:200 |
| GAMMA | PE3 | 65000:888 | 65000:300 |

Routes were being exported with incorrect RTs, so remote PEs couldn't import them.

## Fixes Applied
```
\! PE1 - VRF ALPHA
router bgp 65000
  vrf ALPHA
    no route-target export vpn-ipv4 65000:999
    route-target export vpn-ipv4 65000:100

\! PE2 - VRF BETA
router bgp 65000
  vrf BETA
    no route-target export vpn-ipv4 65000:777
    route-target export vpn-ipv4 65000:200
    no route-target import vpn-ipv4 65000:999

\! PE3 - VRF GAMMA
router bgp 65000
  vrf GAMMA
    no route-target export vpn-ipv4 65000:888
    route-target export vpn-ipv4 65000:300
```

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
