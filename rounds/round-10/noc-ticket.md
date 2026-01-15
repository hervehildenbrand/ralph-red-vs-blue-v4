# NOC Ticket - Round 10

**Ticket ID**: NOC-V4-010
**Time**: 2026-01-15
**Priority**: P1 - Critical
**Affected Service**: VRF ALPHA

## Customer Report

"ALPHA customer routes being rejected, policy may be misconfigured. BGP session is up but routes are not being accepted. Customer states they haven't changed anything on their side."

## Initial Triage Notes

- ALPHA customer reporting route rejection
- BGP session established
- Routes not being installed despite valid advertisements
- Possible routing policy issue
- BETA and GAMMA customers not reporting issues

## Your Mission

1. Diagnose why ALPHA routes are being rejected
2. Check all routing policies including RCFs
3. Apply the fix to restore route acceptance
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
