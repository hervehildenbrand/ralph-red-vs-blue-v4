# NOC Ticket - Round 01

**Ticket ID**: NOC-V4-001
**Time**: 2026-01-15T12:30:00Z
**Priority**: P1 - Critical
**Affected Service**: VRF GAMMA

## Customer Report

"GAMMA customer reports complete service outage. Unable to reach their remote site.
Other customers (ALPHA, BETA) appear unaffected. Customer indicates service was
working earlier today."

## Initial Triage Notes

- Customer confirmed issue is complete connectivity loss
- No planned maintenance windows active
- ALPHA and BETA customers have not reported issues

## Your Mission

1. Diagnose the root cause of the GAMMA VRF outage
2. Apply the fix to restore connectivity
3. Verify ALL 3 VRFs are operational after fix

## Available Resources

- SR-MPLS L3VPN network (18 nodes)
- SSH access to all devices via ContainerLab server
- Diagnostic playbook in `diagnostic-playbook.md`

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

## GAIT Compliance

Document all diagnostic steps and fixes. Commit after each significant action.

## Exit Signal

When fix is complete and ALL VRFs verified operational, output:
```
EXIT_SIGNAL: true
```
