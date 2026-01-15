# NOC Ticket - Round 02

**Ticket ID**: NOC-V4-002
**Time**: 2026-01-15
**Priority**: P1 - Critical
**Affected Service**: VRF BETA

## Customer Report

"BETA customer can initiate connections but responses never arrive. Outbound traffic appears to leave but nothing comes back. Other customers (ALPHA, GAMMA) are unaffected."

## Initial Triage Notes

- Customer confirmed asymmetric connectivity issue
- Ping from CE2 shows "Request timeout"
- No recent configuration changes logged
- ALPHA and GAMMA customers have not reported issues

## Your Mission

1. Diagnose the root cause of the BETA VRF one-way connectivity
2. Apply the fix to restore bidirectional connectivity
3. Verify ALL 3 VRFs are operational after fix

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
