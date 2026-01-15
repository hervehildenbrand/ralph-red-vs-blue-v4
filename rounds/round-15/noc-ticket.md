# NOC Ticket - Round 15

**Ticket ID**: NOC-V4-015
**Time**: 2026-01-15
**Priority**: P1 - Critical
**Affected Service**: VRF BETA

## Customer Report

"BETA VPN completely down. PE6 showing ISIS metric changes in logs. Multiple alarms firing. Customer escalating - this is their production circuit and has been down for 30 minutes."

## Initial Triage Notes

- BETA VPN complete outage
- PE6 ISIS metric alarm triggered
- Multiple monitoring alerts
- Customer escalation in progress
- High pressure to restore quickly
- **WARNING**: Logs may be misleading - verify actual root cause

## Your Mission

1. Diagnose the root cause of BETA VPN outage
2. Investigate PE6 ISIS alerts (may or may not be related)
3. Do not be distracted by red herrings
4. Apply the fix to restore BETA VPN connectivity
5. Verify ALL 3 VRFs are operational after fix

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
