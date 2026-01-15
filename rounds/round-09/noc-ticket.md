# NOC Ticket - Round 09

**Ticket ID**: NOC-V4-009
**Time**: 2026-01-15
**Priority**: P1 - Critical
**Affected Service**: Multiple VRFs

## Customer Report

"Routes visible in BGP but traffic black-holing to specific destinations. We can see the routes in 'show ip route' and 'show ip bgp' but traffic is being dropped. Ping shows 100% loss despite valid routing."

## Initial Triage Notes

- Routes are present and appear valid
- BGP sessions are established
- Traffic is being black-holed
- Issue may affect multiple destinations
- Forwarding plane issue suspected

## Your Mission

1. Diagnose why traffic is black-holing despite valid routes
2. Check BGP attributes, especially next-hop resolution
3. Apply the fix to restore proper forwarding
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
