# Round 4 Attack Specification

## Attack ID: INT-E4 - MTU Black Hole

## Target
- **Device**: P2
- **Interface**: Ethernet3
- **Difficulty**: Expert

## Objective

Create an MTU black hole by reducing the MTU on P2's Ethernet3 interface to 1400. This causes large packets (jumbo frames, large file transfers) to be silently dropped while small packets (DNS, simple web requests) work fine.

## Attack Commands

Apply on P2:
```
configure terminal
interface Ethernet3
  mtu 1400
exit
end
write memory
```

## Execution

Connect to P2 via:
```bash
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-p2 Cli -c 'configure terminal
interface Ethernet3
mtu 1400
exit
end
write memory'"
```

## Verification

After attack, verify MTU black hole:
```bash
# Check MTU on interface
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-p2 Cli -c 'show interfaces Ethernet3 | include MTU'"

# Small packets should work
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 -s 64 192.168.4.2"

# Large packets may fail
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 -s 1400 192.168.4.2"
```

Expected result: **Small packets work, large packets fail** through paths using P2.

## Success Criteria

- [ ] MTU reduced to 1400 on P2 Ethernet3
- [ ] Small packets still passing
- [ ] Large packets (>1400 bytes) being dropped
- [ ] Configuration saved

## NOC Ticket

> **Ticket #004**: Customer reports large file transfers fail but email and web browsing work fine.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
