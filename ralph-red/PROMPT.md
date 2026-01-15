# Round 15 Attack Specification - FINAL BOSS

## Attack ID: ML-E4 - RR Policy Corruption + Decoy

## Target
- **Devices**: PE5 (Real Issue) + PE6 (Decoy)
- **Impact**: BETA VPN completely down, misdirection to PE6
- **Difficulty**: ULTIMATE

## Objective

Create a multi-layer attack with misdirection:
1. **PE5 (Real Issue)**: BGP inbound policy that silently rejects all VPN routes from RRs
2. **PE6 (Decoy)**: ISIS metric change to create log noise and misdirect investigation

## Attack Commands

### PE5 - Real Issue (Silent VPN Route Rejection)
```
configure terminal
ip prefix-list DENY-ALL seq 10 deny 0.0.0.0/0 le 32
route-map RR-BLOCK-IN deny 10
  match ip address prefix-list DENY-ALL
route-map RR-BLOCK-IN deny 20
exit
router bgp 65000
  neighbor 10.0.0.1 route-map RR-BLOCK-IN in
  neighbor 10.0.0.2 route-map RR-BLOCK-IN in
exit
end
write memory
```

### PE6 - Decoy (ISIS Metric Change)
```
configure terminal
interface Ethernet1
  isis metric 999
exit
end
write memory
```

## Execution

```bash
# PE5 - Silent route rejection (BGP sessions UP, routes rejected)
ssh labuser@<server-ip> "docker exec -i clab-red-vs-blue-v3-pe5 Cli" <<'EOFCLI'
enable
configure
ip prefix-list DENY-ALL seq 10 deny 0.0.0.0/0 le 32
route-map RR-BLOCK-IN deny 10
match ip address prefix-list DENY-ALL
exit
route-map RR-BLOCK-IN deny 20
exit
router bgp 65000
neighbor 10.0.0.1 route-map RR-BLOCK-IN in
neighbor 10.0.0.2 route-map RR-BLOCK-IN in
exit
exit
write memory
EOFCLI

# PE6 - Decoy metric change
ssh labuser@<server-ip> "docker exec -i clab-red-vs-blue-v3-pe6 Cli" <<'EOFCLI'
enable
configure
interface Ethernet1
isis metric 999
exit
exit
write memory
EOFCLI
```

## Verification

Check that BGP sessions are UP but routes are filtered:
```bash
# BGP session should show Established
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe5 Cli -c 'show bgp summary'"

# VRF routes should be missing
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe5 Cli -c 'show ip route vrf BETA'"
```

## Success Criteria

- [ ] PE5 BGP sessions UP (10.0.0.1 and 10.0.0.2)
- [ ] PE5 route-map RR-BLOCK-IN applied inbound
- [ ] PE5 BETA VRF missing remote routes (silently filtered)
- [ ] PE6 Ethernet1 ISIS metric changed to 999 (decoy)
- [ ] BETA VRF ping fails

## NOC Ticket

> **Ticket #015**: BETA VPN completely down. PE6 showing ISIS metric changes in logs. Multiple alarms firing.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
