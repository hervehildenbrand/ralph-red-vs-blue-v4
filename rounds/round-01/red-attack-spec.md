# Round 1 Attack Specification

## Attack ID: ML-E6 - Triple-Layer Attack

## Target
- **Device**: PE3
- **VRF**: GAMMA
- **Difficulty**: CCIE+ Expert / Ultimate

## Objective

Break GAMMA VRF connectivity by applying a multi-layer attack that requires Blue to identify and fix 3 separate issues across ISIS, MPLS, and BGP layers.

## Attack Components

You MUST apply ALL 3 components on PE3:

### Component 1: Remove ISIS from uplink
```
configure terminal
interface Ethernet1
  no isis enable CORE
exit
```

### Component 2: Remove Segment Routing from ISIS
```
router isis CORE
  no segment-routing mpls
exit
```

### Component 3: Remove BGP extended community
```
router bgp 65000
  no neighbor RR send-community extended
end
write memory
```

## Execution

Connect to PE3 via:
```bash
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-pe3 Cli -c '[commands]'"
```

## Verification

After attack, verify GAMMA VRF is broken:
```bash
ssh labuser@<server-ip> "docker exec clab-red-vs-blue-v3-ce3 ping -c 3 192.168.6.2"
```

Expected result: **100% packet loss** for GAMMA VRF.

Other VRFs (ALPHA, BETA) should remain operational (0% loss).

## Success Criteria

- [ ] All 3 attack components applied to PE3
- [ ] GAMMA VRF shows 100% packet loss
- [ ] ALPHA VRF shows 0% packet loss (unaffected)
- [ ] BETA VRF shows 0% packet loss (unaffected)
- [ ] Configuration saved with `write memory`

## NOC Ticket (For Blue Team)

After attack verification, the following NOC ticket will be delivered to Blue:

> **Ticket #001**: GAMMA customer reports complete service outage. ALPHA and BETA customers unaffected.

## GAIT Compliance

Document all commands executed in the attack log. Commit after each significant action.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
