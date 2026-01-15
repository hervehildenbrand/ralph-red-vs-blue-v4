# NOC Ticket - Round 15 (FINAL)

**Ticket ID**: NOC-V4-015
**Time**: 2026-01-15
**Priority**: P1 - Critical
**Affected Service**: BETA VPN - Complete outage

## Customer Report

"BETA VPN is completely down. Our monitoring shows PE6 has ISIS metric changes in logs. Multiple alarms are firing across the network."

## Initial Triage Notes

- BETA VPN complete outage
- PE6 ISIS metric alarms visible in logs
- Multiple alarms - may be related or separate issues
- BGP sessions may or may not be affected
- CAUTION: Obvious alerts may be distracting from root cause

## Your Mission

1. Investigate BGP VPN route exchange carefully
2. Check received routes vs installed routes on all BETA PEs
3. Look for policy filtering (may be silent)
4. Don't assume the obvious alarm (PE6 ISIS) is the root cause
5. Fix all issues and verify ALL 3 VRFs operational

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
