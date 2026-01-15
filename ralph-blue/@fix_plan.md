# Ralph Blue - Task Plan

## Current Round

See PROMPT.md for NOC ticket and troubleshooting context.

## Task Status

- [ ] Read NOC ticket from PROMPT.md
- [ ] Connect to ContainerLab server
- [ ] Diagnose issue (layer-by-layer analysis)
- [ ] Apply fix to correct device(s)
- [ ] Verify fix success (all 3 VRFs operational)
- [ ] Document diagnosis in rounds/round-XX/blue-diagnosis.log
- [ ] Output EXIT_SIGNAL: true

## Verification Commands

```bash
# VRF ALPHA connectivity test
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"

# VRF BETA connectivity test
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"

# VRF GAMMA connectivity test
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce3 ping -c 3 192.168.6.2"
```

## Diagnostic Playbook

1. **Layer 1**: Check interface status
2. **IGP (ISIS)**: Check adjacencies, routes
3. **MPLS/SR**: Check labels, LFIB
4. **BGP**: Check sessions, VPN routes
5. **VRF**: Check RT import/export, routing table

## Notes

- Follow GAIT protocol: every action must be committed
- Document all diagnostic steps
- Success = ALL 3 VRFs operational (0% packet loss)
