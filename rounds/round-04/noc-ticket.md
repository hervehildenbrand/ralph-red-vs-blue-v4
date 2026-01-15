# NOC Ticket - Round 04

**Ticket ID**: NOC-V4-004
**Time**: 2026-01-15
**Priority**: P2 - High
**Affected Service**: Large data transfers

## Customer Report

"Customer reports large file transfers fail but email and web browsing work fine. FTP and SCP transfers hang or timeout. Small files sometimes work, large files always fail."

## Initial Triage Notes

- Basic connectivity appears functional
- Small packet tests (ping) succeed
- Large file transfers consistently fail
- Issue affects transfers over certain size threshold
- Web browsing and email working normally

## Your Mission

1. Diagnose the root cause of the large transfer failures
2. Identify where packets are being dropped
3. Apply the fix to restore full connectivity
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
