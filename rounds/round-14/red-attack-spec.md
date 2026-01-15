# Round 14 Attack Specification

## Attack ID: V6-E3 - Dual-Stack Asymmetry

## Target
- **Device**: P3
- **Component**: ISIS IPv6 multi-topology
- **Difficulty**: Expert

## Objective

Create a dual-stack asymmetry by disabling ISIS multi-topology for IPv6. This causes IPv6 traffic to use the same topology as IPv4, potentially creating different paths for IPv4 and IPv6 traffic and breaking IPv6 connectivity.

## Attack Commands

Apply on P3:
```
configure terminal
router isis CORE
  address-family ipv6 unicast
    no multi-topology
exit
exit
end
write memory
```

## Execution

Connect to P3 via:
```bash
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p3 Cli -c 'configure terminal
router isis CORE
address-family ipv6 unicast
no multi-topology
exit
exit
end
write memory'"
```

## Verification

After attack, verify IPv6 issues:
```bash
# Check ISIS IPv6 configuration
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p3 Cli -c 'show running-config section isis'"

# Check IPv6 routing
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p3 Cli -c 'show ipv6 route'"

# Verify IPv6 connectivity issues
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping6 -c 3 2001:db8:4::2"

# Verify IPv4 still works
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"
```

Expected result: **IPv6 connectivity issues while IPv4 works normally**.

## Success Criteria

- [ ] ISIS IPv6 multi-topology disabled on P3
- [ ] IPv6 routing affected
- [ ] IPv6 connectivity broken
- [ ] IPv4 connectivity still working
- [ ] Configuration saved

## NOC Ticket

> **Ticket #014**: IPv6 connectivity issues, IPv4 working normally.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
