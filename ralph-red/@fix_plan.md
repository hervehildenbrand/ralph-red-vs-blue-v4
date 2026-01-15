# Ralph Red - Task Plan

## Current Round

See PROMPT.md for current round attack specification.

## Task Status

- [ ] Read attack specification from PROMPT.md
- [ ] Connect to ContainerLab server
- [ ] Execute attack commands on target device(s)
- [ ] Verify attack success (target VRF broken)
- [ ] Document attack in rounds/round-XX/red-attack.log
- [ ] Output EXIT_SIGNAL: true

## Attack Verification Commands

```bash
# VRF ALPHA connectivity test
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"

# VRF BETA connectivity test
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"

# VRF GAMMA connectivity test
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce3 ping -c 3 192.168.6.2"
```

## Notes

- Follow GAIT protocol: every action must be committed
- Document all commands in attack log
- Do not reveal attack details in NOC ticket
