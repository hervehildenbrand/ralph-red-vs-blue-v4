# Round 3 Attack Specification

## Attack ID: SR-E2 - SRGB Mismatch

## Target
- **Device**: P3
- **Component**: Segment Routing Global Block
- **Difficulty**: Expert

## Objective

Break SR-MPLS forwarding by changing the SRGB (Segment Routing Global Block) range on P3. This causes label mismatches where other routers expect labels in range 16000-23999 but P3 uses 800000-865535.

## Attack Commands

Apply on P3:
```
configure terminal
router isis CORE
  segment-routing mpls
    no global-block
    global-block 800000 865535
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
segment-routing mpls
no global-block
global-block 800000 865535
exit
exit
end
write memory'"
```

## Verification

After attack, verify traffic through P3 is affected:
```bash
# Check SRGB mismatch
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-p3 Cli -c 'show isis segment-routing global-blocks'"

# Verify connectivity issues
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce3 ping -c 3 192.168.6.2"
```

Expected result: **Intermittent packet loss** for traffic traversing P3.

## Success Criteria

- [ ] SRGB changed to 800000-865535 on P3
- [ ] P3 shows different SRGB than other routers
- [ ] Traffic through P3 showing packet loss
- [ ] Configuration saved

## NOC Ticket

> **Ticket #003**: Intermittent packet loss affecting traffic through specific path.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
