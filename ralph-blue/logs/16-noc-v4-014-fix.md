# NOC-V4-014 Fix - BETA VRF Remote Site Outage

## Ticket
- **ID**: NOC-V4-014
- **Priority**: P1 - Critical
- **Symptom**: BETA VRF complete connectivity loss at remote site

## Root Cause
PE5 BETA VRF missing IPv4 import route-target. Configuration had:
```
route-target import vpn-ipv6 65000:200   # IPv6 only!
route-target export vpn-ipv4 65000:200
route-target export vpn-ipv6 65000:200
```

Missing: `route-target import vpn-ipv4 65000:200`

This prevented PE5 from importing BETA IPv4 routes from other PEs.

## Fix Applied
```
router bgp 65000
  vrf BETA
    route-target import vpn-ipv4 65000:200
```

## Verification
All VRFs operational with 0% packet loss:
- ALPHA: CE1 -> CE4 ✅
- BETA: CE2 -> CE5 ✅
- GAMMA: CE3 -> CE6 ✅

## Timestamp
$(date -u '+%Y-%m-%d %H:%M:%S UTC')
