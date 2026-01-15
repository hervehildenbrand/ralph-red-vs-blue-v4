# NOC-V4-015 Fix - BETA VPN Complete Outage

## Ticket
- **ID**: NOC-V4-015
- **Priority**: P1 - Critical
- **Symptom**: BETA VPN complete outage, PE6 ISIS alarms (red herring)

## Root Cause
PE5 had a malicious route-map `RR-BLOCK-IN` applied to both RR neighbors:
```
neighbor 10.0.0.1 route-map RR-BLOCK-IN in
neighbor 10.0.0.2 route-map RR-BLOCK-IN in
```

The route-map had only deny statements:
```
route-map RR-BLOCK-IN deny 10
   match ip address prefix-list DENY-ALL
route-map RR-BLOCK-IN deny 20
```

This silently rejected ALL incoming VPNv4 routes from the RRs with **PolicyReject**.

Note: PE6 ISIS metric alarms mentioned in ticket were a red herring - the real issue was policy-based route filtering on PE5.

## Fix Applied
Removed the blocking route-map from PE5:
```
router bgp 65000
  no neighbor 10.0.0.1 route-map RR-BLOCK-IN in
  no neighbor 10.0.0.2 route-map RR-BLOCK-IN in
```

## Verification
All VRFs operational with 0% packet loss:
- ALPHA: CE1 -> CE4 ✅
- BETA: CE2 -> CE5 ✅
- GAMMA: CE3 -> CE6 ✅

## Timestamp
$(date -u '+%Y-%m-%d %H:%M:%S UTC')
