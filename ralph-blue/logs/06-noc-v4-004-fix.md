# NOC-V4-004 Fix - 2026-01-15T06:22:25Z

## Symptom
Customer reported large file transfers fail. Investigation found ALL 3 VRFs had complete outage.

## Root Cause
**MTU mismatch on P2 Ethernet3** (link to P3)
- P2 Et3: MTU 1400 (incorrect)
- P3 Et2: MTU 1500 (default)

The MTU mismatch caused ISIS adjacency failure between P2 and P3, which:
1. Isolated the DC-side of the network (P3, P4, PE4, PE5, PE6)
2. PE4/5/6 lost ISIS routes to RRs (10.0.0.1, 10.0.0.2)
3. BGP sessions from PE4/5/6 to RRs went Active (down)
4. VPN routes for DC-side (192.168.4/5/6.0/24) disappeared
5. Complete VRF outage for east-west traffic

## Fix Applied
```
configure
interface Ethernet3
  no mtu
end
```

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
