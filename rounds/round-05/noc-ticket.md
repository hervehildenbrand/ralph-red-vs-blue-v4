# NOC Ticket - Round 05

**Ticket ID**: NOC-V4-005
**Time**: 2026-01-15
**Priority**: P1 - Critical
**Affected Service**: ALL VRFs (ALPHA, BETA, GAMMA)

## Customer Report

"Multiple customers reporting various connectivity issues - ALPHA, BETA, and GAMMA all affected. Each customer is experiencing outages. This appears to be a widespread issue."

## Initial Triage Notes

- ALL three customer VRFs reporting issues simultaneously
- Each VRF may have different root cause
- No common maintenance window
- Underlay appears stable (ISIS adjacencies up)
- BGP sessions established

## Your Mission

1. Diagnose the root cause for EACH VRF's connectivity issue
2. Identify whether issues are related or independent
3. Apply fixes to restore connectivity for ALL VRFs
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
