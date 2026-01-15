# Round 5 Attack Specification

## Attack ID: XV-E6 - Multi-VRF Cascade

## Target
- **Devices**: PE1, PE2, PE3 (ALL VRFs affected)
- **VRFs**: ALPHA, BETA, GAMMA
- **Difficulty**: Ultimate (CCIE+)

## Objective

Create a cascading route-target corruption affecting ALL three VRFs simultaneously. Each VRF has its own RT issue, making diagnosis extremely complex as Blue must identify and fix THREE separate problems.

## Attack Commands

### PE1 - ALPHA VRF RT Corruption
```
configure terminal
vrf instance ALPHA
  no route-target export 65000:100
  route-target export 65000:999
exit
end
write memory
```

### PE2 - BETA VRF RT Corruption
```
configure terminal
vrf instance BETA
  route-target import 65000:999
exit
end
write memory
```

### PE3 - GAMMA VRF RT Corruption
```
configure terminal
vrf instance GAMMA
  no route-target export 65000:300
  route-target export 65000:888
exit
end
write memory
```

## Execution

Connect to each PE via:
```bash
# PE1 - ALPHA corruption
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'configure terminal
vrf instance ALPHA
no route-target export 65000:100
route-target export 65000:999
exit
end
write memory'"

# PE2 - BETA corruption (adds wrong import)
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe2 Cli -c 'configure terminal
vrf instance BETA
route-target import 65000:999
exit
end
write memory'"

# PE3 - GAMMA corruption
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe3 Cli -c 'configure terminal
vrf instance GAMMA
no route-target export 65000:300
route-target export 65000:888
exit
end
write memory'"
```

## Verification

After attack, verify ALL VRFs are broken:
```bash
# VRF ALPHA - should fail
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"

# VRF BETA - should fail
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"

# VRF GAMMA - should fail
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce3 ping -c 3 192.168.6.2"
```

Expected result: **100% packet loss** on ALL VRFs.

## Success Criteria

- [ ] PE1 ALPHA RT export changed to 65000:999
- [ ] PE2 BETA RT import 65000:999 added (creates leak potential)
- [ ] PE3 GAMMA RT export changed to 65000:888
- [ ] ALL 3 VRFs showing packet loss
- [ ] All configurations saved

## NOC Ticket

> **Ticket #005**: Multiple customers reporting various connectivity issues - ALPHA, BETA, and GAMMA all affected.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
