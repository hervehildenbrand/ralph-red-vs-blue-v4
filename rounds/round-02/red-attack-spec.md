# Round 2 Attack Specification

## Attack ID: MIS-E4 - One-Way ACL (Asymmetric Block)

## Target
- **Device**: PE2
- **VRF**: BETA
- **Difficulty**: Expert

## Objective

Break BETA VRF by applying an ACL that blocks return traffic. This creates an asymmetric failure where outbound traffic works but responses never arrive.

## Attack Commands

Apply on PE2:
```
configure terminal
ip access-list BLOCK-RETURN
  10 deny ip any 192.168.5.0/24
  20 permit ip any any
exit
interface Ethernet3
  ip access-group BLOCK-RETURN in
exit
end
write memory
```

## Execution

Connect to PE2 via:
```bash
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe2 Cli -c '[commands]'"
```

## Verification

After attack, verify BETA VRF is broken:
```bash
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"
```

Expected result: **100% packet loss** for BETA VRF (request timeout).

## Success Criteria

- [ ] ACL BLOCK-RETURN created on PE2
- [ ] ACL applied inbound on Ethernet3
- [ ] BETA VRF shows 100% packet loss
- [ ] ALPHA and GAMMA VRFs remain operational
- [ ] Configuration saved

## NOC Ticket

> **Ticket #002**: BETA customer can initiate connections but responses never arrive.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
