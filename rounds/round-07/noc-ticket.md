# NOC Ticket - Round 07

**Ticket ID**: NOC-V4-007
**Time**: 2026-01-15
**Priority**: P2 - High
**Affected Service**: VRF BETA

## Customer Report

"Customer routes exist but traffic is being dropped somewhere. We can see the routes in the routing table but ping and traceroute show drops. The routes look correct but something is causing the traffic to fail."

## Initial Triage Notes

- Routes are present in routing table
- BGP sessions established and routes learned
- Traffic not reaching destination despite valid routes
- Possible policy or attribute issue
- ALPHA and GAMMA customers not reporting issues

## Your Mission

1. Diagnose why traffic is failing despite routes existing
2. Check BGP attributes and policies on the routes
3. Apply the fix to restore proper traffic forwarding
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
