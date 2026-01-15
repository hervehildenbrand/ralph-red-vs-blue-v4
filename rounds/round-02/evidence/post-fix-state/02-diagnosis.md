# Diagnosis - 2026-01-15T05:41:48Z

## Root Cause
PE3's Ethernet1 interface (uplink to P2) is **missing ISIS configuration**.

## Evidence
1. BGP sessions to RRs (10.0.0.1, 10.0.0.2) in Active state - cannot connect
2. show isis interface brief on PE3: Only Loopback0 listed, Et1 missing
3. show ip route 10.0.0.1 on PE3: No route (unreachable)
4. PE1 comparison: Et1 IS in ISIS with adjacency up

## Impact
- PE3 isolated from SR-MPLS core
- No reachability to RRs via loopback
- BGP VPNv4 sessions cannot establish
- VRF GAMMA routes not exchanged

## Fix Required
Enable ISIS on PE3 Ethernet1:
```
configure
interface Ethernet1
  isis enable CORE
  isis network point-to-point
```
