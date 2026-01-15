# Round 13 Attack Specification

## Attack ID: SR-E6 - Anycast SID Conflict

## Target
- **Devices**: PE1, PE2
- **Component**: Segment Routing Anycast SID
- **Difficulty**: Ultimate (CCIE+)

## Objective

Create an anycast SID conflict by configuring identical loopback addresses and node-segment indexes on PE1 and PE2. This creates ambiguous forwarding where traffic could be sent to either PE unpredictably.

## Attack Commands

### PE1 - Create Loopback1 with anycast address
```
configure terminal
interface Loopback1
  ip address 10.255.255.1/32
exit
router isis CORE
  interface Loopback1
    isis enable
    node-segment ipv4 index 100
exit
exit
end
write memory
```

### PE2 - Create identical Loopback1 (conflict)
```
configure terminal
interface Loopback1
  ip address 10.255.255.1/32
exit
router isis CORE
  interface Loopback1
    isis enable
    node-segment ipv4 index 100
exit
exit
end
write memory
```

## Execution

Connect to PE1 and PE2 via:
```bash
# PE1 - Create anycast loopback
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'configure terminal
interface Loopback1
ip address 10.255.255.1/32
exit
router isis CORE
interface Loopback1
isis enable
node-segment ipv4 index 100
exit
exit
end
write memory'"

# PE2 - Create conflicting anycast loopback
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe2 Cli -c 'configure terminal
interface Loopback1
ip address 10.255.255.1/32
exit
router isis CORE
interface Loopback1
isis enable
node-segment ipv4 index 100
exit
exit
end
write memory'"
```

## Verification

After attack, verify anycast conflict:
```bash
# Check SR SIDs on both PEs
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'show isis segment-routing sid'"
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe2 Cli -c 'show isis segment-routing sid'"

# Check MPLS forwarding for conflicts
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-p1 Cli -c 'show mpls lfib route'"

# Verify unpredictable load balancing
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce1 ping -c 5 192.168.4.2"
```

Expected result: **Load balancing not working as expected**, traffic unpredictable.

## Success Criteria

- [ ] PE1 Loopback1 created with 10.255.255.1/32 and index 100
- [ ] PE2 Loopback1 created with same address and index
- [ ] ISIS advertising conflicting SIDs
- [ ] Load balancing showing unexpected behavior
- [ ] Configuration saved

## NOC Ticket

> **Ticket #013**: Load balancing not working as expected between sites.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
