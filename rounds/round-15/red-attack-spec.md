# Round 15 Attack Specification

## Attack ID: ML-E4 - RR Policy Corruption + Decoy

## Target
- **Devices**: PE5 (real attack), PE6 (decoy)
- **Component**: BGP policy and ISIS metric
- **Difficulty**: Ultimate (CCIE+)

## Objective

Create a multi-layer attack with a decoy. PE5 has a policy that blocks all routes from route reflectors, causing BETA VPN to fail. PE6 has an ISIS metric change as a decoy to distract investigation.

## Attack Commands

### PE5 - Real attack (block RR routes)
```
configure terminal
ip prefix-list DENY-ALL deny 0.0.0.0/0 le 32
route-map RR-BLOCK-IN deny 10
  match ip address prefix-list DENY-ALL
exit
route-map RR-BLOCK-IN deny 20
exit
router bgp 65000
  neighbor RR route-map RR-BLOCK-IN in
exit
end
write memory
```

### PE6 - Decoy (ISIS metric change)
```
configure terminal
interface Ethernet1
  isis metric 999
exit
end
write memory
```

## Execution

Connect to PE5 and PE6 via:
```bash
# PE5 - Block RR routes (real attack)
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe5 Cli -c 'configure terminal
ip prefix-list DENY-ALL deny 0.0.0.0/0 le 32
route-map RR-BLOCK-IN deny 10
match ip address prefix-list DENY-ALL
exit
route-map RR-BLOCK-IN deny 20
exit
router bgp 65000
neighbor RR route-map RR-BLOCK-IN in
exit
end
write memory'"

# PE6 - Decoy metric change
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe6 Cli -c 'configure terminal
interface Ethernet1
isis metric 999
exit
end
write memory'"
```

## Verification

After attack, verify BETA VPN is broken:
```bash
# Check PE5 BGP
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe5 Cli -c 'show ip bgp summary'"

# Check PE6 ISIS (decoy)
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe6 Cli -c 'show isis interface'"

# Verify BETA VPN broken
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"
```

Expected result: **BETA VPN completely down**, with PE6 ISIS changes as distraction.

## Success Criteria

- [ ] PE5 prefix-list DENY-ALL created
- [ ] PE5 route-map RR-BLOCK-IN created and applied
- [ ] PE6 Ethernet1 ISIS metric set to 999 (decoy)
- [ ] BETA VPN showing 100% packet loss
- [ ] All configurations saved

## NOC Ticket

> **Ticket #015**: BETA VPN completely down. PE6 showing ISIS metric changes in logs. Multiple alarms firing.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
