# NOC Ticket - Round 14

**Ticket ID**: NOC-V4-014
**Time**: 2026-01-15
**Priority**: P2 - High
**Affected Service**: IPv6 connectivity

## Customer Report

"IPv6 connectivity issues, IPv4 working normally. Dual-stack customers report IPv6 timeouts while IPv4 works fine. Some sites can reach IPv6 destinations, others cannot."

## Initial Triage Notes

- IPv6-specific connectivity failure
- IPv4 traffic unaffected
- Dual-stack environment
- Asymmetric behavior between protocols
- ISIS or routing topology issue suspected

## Your Mission

1. Diagnose why IPv6 is failing while IPv4 works
2. Check ISIS IPv6 address-family configuration
3. Apply the fix to restore IPv6 connectivity
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
