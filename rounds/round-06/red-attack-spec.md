# Round 6 Attack Specification

## Attack ID: POL-E2 - Route-Map Sequence Swap

## Target
- **Device**: PE1
- **VRF**: ALPHA
- **Difficulty**: Expert

## Objective

Break ALPHA VRF by replacing the CE1-IN route-map with an inverted version. The new route-map has a deny statement as the first sequence (5) and permit as the second (10), effectively blocking all routes from CE1.

## Attack Commands

Apply on PE1:
```
configure terminal
no route-map CE1-IN
route-map CE1-IN deny 5
exit
route-map CE1-IN permit 10
exit
router bgp 65000
  vrf ALPHA
    neighbor 192.168.1.1 route-map CE1-IN in
exit
exit
end
write memory
```

## Execution

Connect to PE1 via:
```bash
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'configure terminal
no route-map CE1-IN
route-map CE1-IN deny 5
exit
route-map CE1-IN permit 10
exit
router bgp 65000
vrf ALPHA
neighbor 192.168.1.1 route-map CE1-IN in
exit
exit
end
write memory'"
```

## Verification

After attack, verify ALPHA VRF routes are rejected:
```bash
# Check route-map
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'show route-map CE1-IN'"

# Verify ALPHA VRF broken
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"

# Check BGP routes in VRF
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'show ip bgp vrf ALPHA summary'"
```

Expected result: **100% packet loss** for ALPHA VRF.

## Success Criteria

- [ ] Original CE1-IN route-map removed
- [ ] New CE1-IN created with deny 5 / permit 10
- [ ] Route-map applied to CE1 neighbor
- [ ] ALPHA VRF shows 100% packet loss
- [ ] BETA and GAMMA VRFs remain operational
- [ ] Configuration saved

## NOC Ticket

> **Ticket #006**: ALPHA customer routes not appearing in routing table.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
