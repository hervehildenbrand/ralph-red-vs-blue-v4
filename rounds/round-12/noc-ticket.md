# NOC Ticket - Round 12

**Ticket ID**: NOC-V4-012
**Time**: 2026-01-15
**Priority**: P2 - High
**Affected Service**: Routing efficiency

## Customer Report

"Suboptimal routing reported, traffic taking longer path. Latency has increased and traceroute shows traffic going through unexpected hops. Service still works but performance is degraded."

## Initial Triage Notes

- Traffic is flowing but taking suboptimal paths
- Latency increased compared to baseline
- Traceroute shows unexpected routing
- Multiple P routers may have metric changes
- Service functional but degraded

## Your Mission

1. Diagnose which path changes are causing suboptimal routing
2. Compare current metrics against expected values
3. Apply the fix to restore optimal routing
4. Verify ALL 3 VRFs are operational after fix

## Verification Commands

```bash
# VRF ALPHA
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"

# VRF BETA
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"

# VRF GAMMA
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce3 ping -c 3 192.168.6.2"
```

## Success Criteria

ALL VRFs must show 0% packet loss.

## Exit Signal

When fix is complete and ALL VRFs verified operational, output:
```
EXIT_SIGNAL: true
```
