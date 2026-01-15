# NOC-V4-012 Fix - 2026-01-15T07:56:47Z

## Investigation Summary

Audited ISIS metrics across all core routers. Found multiple anomalies:

| Device | Interface | Peer | Metric | Assessment |
|--------|-----------|------|--------|------------|
| P1 | Et1 | RR1 | 50 | Elevated but RR is control-plane only - NO FIX NEEDED |
| P2 | Et2 | P1 | 50 | Elevated but symmetric - may be intentional - NO FIX NEEDED |
| **P3** | **Et3** | **P4** | **16777214** | **MAX METRIC - FIXED** |

## Root Cause
P3 Ethernet3 (link to P4) had ISIS max-metric (16777214) configured, effectively removing the P3-P4 link from transit routing. This forced DC traffic to take longer paths, causing increased latency.

## Fix Applied (Targeted)
```
! P3 only - targeted fix
configure
interface Ethernet3
  isis metric 10
end
```

## What Was NOT Changed
- P1 Et1 metric 50 (RR link - control plane only)
- P2 Et2 metric 50 (may be intentional for traffic engineering)

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ (RTT improved ~2.87→2.57ms) |
