# Round 12 Attack Specification

## Attack ID: MIS-E3 - Metric Maze

## Target
- **Devices**: P1, P2, P3
- **Component**: ISIS interface metrics
- **Difficulty**: Expert+

## Objective

Create a metric maze with decoys. Set low metrics on P1 and P2 interfaces as decoys (appear suspicious but don't cause issues), while setting an extremely high metric on P3 that actually breaks routing.

## Attack Commands

### P1 - Decoy (low metric, not harmful)
```
configure terminal
interface Ethernet1
  isis metric 50
exit
end
write memory
```

### P2 - Decoy (low metric, not harmful)
```
configure terminal
interface Ethernet2
  isis metric 50
exit
end
write memory
```

### P3 - Real attack (maximum metric causes black hole)
```
configure terminal
interface Ethernet3
  isis metric 16777214
exit
end
write memory
```

## Execution

Connect to P1, P2, and P3 via:
```bash
# P1 - Decoy metric change
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p1 Cli -c 'configure terminal
interface Ethernet1
isis metric 50
exit
end
write memory'"

# P2 - Decoy metric change
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p2 Cli -c 'configure terminal
interface Ethernet2
isis metric 50
exit
end
write memory'"

# P3 - Real attack with max metric
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p3 Cli -c 'configure terminal
interface Ethernet3
isis metric 16777214
exit
end
write memory'"
```

## Verification

After attack, verify suboptimal routing:
```bash
# Check ISIS metrics on all P routers
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p1 Cli -c 'show isis interface'"
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p2 Cli -c 'show isis interface'"
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p3 Cli -c 'show isis interface'"

# Verify connectivity issues
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"
```

Expected result: **Suboptimal routing** with P3 interface essentially unusable.

## Success Criteria

- [ ] P1 Ethernet1 metric set to 50 (decoy)
- [ ] P2 Ethernet2 metric set to 50 (decoy)
- [ ] P3 Ethernet3 metric set to 16777214 (real attack)
- [ ] Traffic taking suboptimal path
- [ ] All configurations saved

## NOC Ticket

> **Ticket #012**: Suboptimal routing reported, traffic taking longer path.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
