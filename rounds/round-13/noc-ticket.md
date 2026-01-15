# NOC Ticket - Round 13

**Ticket ID**: NOC-V4-013
**Time**: 2026-01-15
**Priority**: P2 - High
**Affected Service**: Load balancing

## Customer Report

"Load balancing not working as expected between sites. Traffic that should be distributed is going to wrong destinations. Some connections work, others fail randomly."

## Initial Triage Notes

- Load balancing behavior is unpredictable
- Traffic reaching wrong destinations
- Random success/failure pattern
- May be related to ECMP or anycast configuration
- Need to check SR SID assignments

## Your Mission

1. Diagnose why load balancing is behaving unexpectedly
2. Check for SID conflicts or anycast misconfigurations
3. Apply the fix to restore proper load balancing
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
