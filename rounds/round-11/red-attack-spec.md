# Round 11 Attack Specification

## Attack ID: INT-E6 - ISIS Metric Oscillation

## Target
- **Devices**: P1, P3
- **Component**: ISIS interface metrics
- **Difficulty**: Expert

## Objective

Create routing instability by setting high ISIS metrics on P1 and P3 interfaces, causing route oscillation and intermittent connectivity as the network reconverges repeatedly.

## Attack Commands

### P1 - High metric on Ethernet2
```
configure terminal
interface Ethernet2
  isis metric 100
exit
end
write memory
```

### P3 - High metric on Ethernet2
```
configure terminal
interface Ethernet2
  isis metric 100
exit
end
write memory
```

## Execution

Connect to P1 and P3 via:
```bash
# P1 - Set high metric
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-p1 Cli -c 'configure terminal
interface Ethernet2
isis metric 100
exit
end
write memory'"

# P3 - Set high metric
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-p3 Cli -c 'configure terminal
interface Ethernet2
isis metric 100
exit
end
write memory'"
```

## Verification

After attack, verify metric changes and instability:
```bash
# Check ISIS database and metrics
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-p1 Cli -c 'show isis database detail'"

# Check for route flapping
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'show ip route'"

# Verify intermittent connectivity
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce1 ping -c 10 192.168.4.2"
```

Expected result: **Intermittent packet loss** and route changes.

## Success Criteria

- [ ] P1 Ethernet2 ISIS metric set to 100
- [ ] P3 Ethernet2 ISIS metric set to 100
- [ ] Routing showing instability or suboptimal paths
- [ ] Intermittent packet loss observed
- [ ] Configuration saved

## NOC Ticket

> **Ticket #011**: Customer reports intermittent packet loss and route changes.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
