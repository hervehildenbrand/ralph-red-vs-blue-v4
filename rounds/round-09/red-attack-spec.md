# Round 9 Attack Specification

## Attack ID: TE-E5 - Next-Hop-Self Missing

## Target
- **Device**: RR1 (Route Reflector)
- **Component**: BGP next-hop-self
- **Difficulty**: Expert

## Objective

Break BGP forwarding by removing next-hop-self from the route reflector's PE-CLIENTS peer group. This causes routes to be reflected with the original next-hop, which may not be reachable from all PEs, creating a black hole.

## Attack Commands

Apply on RR1:
```
configure terminal
router bgp 65000
  neighbor PE-CLIENTS next-hop-unchanged
  no neighbor PE-CLIENTS next-hop-self
exit
end
write memory
```

## Execution

Connect to RR1 via:
```bash
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-rr1 Cli -c 'configure terminal
router bgp 65000
neighbor PE-CLIENTS next-hop-unchanged
no neighbor PE-CLIENTS next-hop-self
exit
end
write memory'"
```

## Verification

After attack, verify next-hop issues:
```bash
# Check RR BGP configuration
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-rr1 Cli -c 'show running-config section bgp'"

# Check BGP routes and next-hops on PE
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'show ip bgp'"

# Verify connectivity issues
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"
```

Expected result: **Routes visible in BGP but traffic black-holing** due to unreachable next-hops.

## Success Criteria

- [ ] next-hop-self removed from PE-CLIENTS group
- [ ] next-hop-unchanged configured
- [ ] Routes show incorrect next-hops
- [ ] Traffic black-holing to destinations
- [ ] Configuration saved

## NOC Ticket

> **Ticket #009**: Routes visible in BGP but traffic black-holing to specific destinations.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
