# NOC Ticket - Round 06

**Ticket ID**: NOC-V4-006
**Time**: 2026-01-15
**Priority**: P1 - Critical
**Affected Service**: VRF ALPHA

## Customer Report

"ALPHA customer routes not appearing in routing table. Customer reports they have full local connectivity but cannot reach remote sites. BGP session appears established but no routes are being learned."

## Initial Triage Notes

- ALPHA customer reporting complete outage to remote sites
- BGP sessions appear established
- Customer CE routes not visible in PE routing table
- BETA and GAMMA customers not reporting issues
- Policy change suspected but not confirmed

## Your Mission

1. Diagnose why ALPHA customer routes are not appearing
2. Check BGP session state and policy configuration
3. Apply the fix to restore route learning
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
