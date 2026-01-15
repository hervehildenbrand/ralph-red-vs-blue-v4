# NOC Ticket - Round 08

**Ticket ID**: NOC-V4-008
**Time**: 2026-01-15
**Priority**: P1 - Critical
**Affected Service**: VRF BETA (possible security issue)

## Customer Report

"BETA customer seeing unexpected routes, possible route leak. Customer is seeing routes in their VRF that don't belong to them. They are concerned about security and connectivity is intermittent."

## Initial Triage Notes

- BETA customer reporting unexpected routes in their routing table
- Routes appear to belong to another customer
- Potential security/compliance concern
- VRF isolation may be compromised
- Need to identify source of route leak

## Your Mission

1. Diagnose the source of the route leak
2. Identify which VRF routes are leaking into BETA
3. Apply the fix to restore proper VRF isolation
4. Verify ALL 3 VRFs are operational and isolated after fix

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

ALL VRFs must show 0% packet loss and proper isolation.

## Exit Signal

When fix is complete and ALL VRFs verified operational, output:
```
EXIT_SIGNAL: true
```
