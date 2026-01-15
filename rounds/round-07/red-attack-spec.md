# Round 7 Attack Specification

## Attack ID: MIS-E5 - Community Strip

## Target
- **Device**: PE5
- **VRF**: BETA
- **Difficulty**: Expert

## Objective

Break BETA VRF traffic engineering by stripping all communities from CE5's routes. This removes critical community tags that control route selection, traffic engineering, or service marking, causing routes to exist but traffic to be incorrectly handled.

## Attack Commands

Apply on PE5:
```
configure terminal
route-map CE5-IN permit 10
  set community none
exit
end
write memory
```

## Execution

Connect to PE5 via:
```bash
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe5 Cli -c 'configure terminal
route-map CE5-IN permit 10
set community none
exit
end
write memory'"
```

## Verification

After attack, verify community stripping:
```bash
# Check route-map
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe5 Cli -c 'show route-map CE5-IN'"

# Check BGP routes and communities
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe5 Cli -c 'show ip bgp vrf BETA'"

# Verify BETA VRF issues
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"
```

Expected result: **Routes exist but traffic is being dropped** due to missing community-based policy decisions.

## Success Criteria

- [ ] CE5-IN route-map modified with "set community none"
- [ ] Communities stripped from CE5 routes
- [ ] BETA VRF showing connectivity issues
- [ ] ALPHA and GAMMA VRFs remain operational
- [ ] Configuration saved

## NOC Ticket

> **Ticket #007**: Customer routes exist but traffic is being dropped somewhere.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
