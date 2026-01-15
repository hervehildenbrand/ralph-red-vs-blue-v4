# NOC Ticket - Round 11

**Ticket ID**: NOC-V4-011
**Time**: 2026-01-15
**Priority**: P2 - High
**Affected Service**: Intermittent connectivity

## Customer Report

"Customer reports intermittent packet loss and route changes. Some pings succeed while others fail. Traceroute shows different paths at different times. The issue seems to come and go."

## Initial Triage Notes

- Intermittent connectivity issues reported
- Routing appears unstable
- Paths changing unexpectedly
- Not a complete outage - some traffic succeeds
- Underlay routing (ISIS) may be involved

## Your Mission

1. Diagnose the cause of the routing instability
2. Check ISIS metrics and topology
3. Apply the fix to restore stable routing
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
