# NOC Ticket - Round 03

**Ticket ID**: NOC-V4-003
**Time**: 2026-01-15
**Priority**: P2 - High
**Affected Service**: Intermittent connectivity

## Customer Report

"Intermittent packet loss affecting traffic through specific path. Some pings succeed while others fail. The issue appears random but customers on certain paths are more affected than others."

## Initial Triage Notes

- Connectivity is intermittent, not complete outage
- Pattern suggests specific path is affected
- Underlay protocol adjacencies appear stable
- No recent maintenance windows

## Your Mission

1. Diagnose the root cause of the intermittent packet loss
2. Identify which path/device is causing the issue
3. Apply the fix to restore consistent connectivity
4. Verify ALL 3 VRFs are operational after fix

## Verification Commands

```bash
# VRF ALPHA
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"

# VRF BETA
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"

# VRF GAMMA
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce3 ping -c 3 192.168.6.2"
```

## Success Criteria

ALL VRFs must show 0% packet loss.

## Exit Signal

When fix is complete and ALL VRFs verified operational, output:
```
EXIT_SIGNAL: true
```
