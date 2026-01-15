# Ralph Blue - Expert Diagnostic Playbook (v4)

## Overview

This playbook contains CCIE+ level diagnostic procedures for the Ralph Red vs Blue v4 challenge. These attacks are designed to be difficult - expect multi-layer issues, misdirection, and subtle failures.

## Quick Reference - Topology

| Device | Loopback | VRF | CE | Subnet |
|--------|----------|-----|-----|--------|
| PE1 | 10.0.0.21 | ALPHA | CE1 | 192.168.1.0/24 |
| PE2 | 10.0.0.22 | BETA | CE2 | 192.168.2.0/24 |
| PE3 | 10.0.0.23 | GAMMA | CE3 | 192.168.3.0/24 |
| PE4 | 10.0.0.24 | ALPHA | CE4 | 192.168.4.0/24 |
| PE5 | 10.0.0.25 | BETA | CE5 | 192.168.5.0/24 |
| PE6 | 10.0.0.26 | GAMMA | CE6 | 192.168.6.0/24 |

| VRF | RT | RD |
|-----|-----|-----|
| ALPHA | 65000:100 | 65000:100 |
| BETA | 65000:200 | 65000:200 |
| GAMMA | 65000:300 | 65000:300 |

## Diagnostic Decision Tree

```
START: VRF Connectivity Failure
  |
  ├─ Which VRFs affected?
  │   ├─ Single VRF → Focus on that VRF's PE pair
  │   ├─ Multiple VRFs → Check core/RR issues
  │   └─ All VRFs → Major infrastructure issue
  |
  ├─ Layer 1-3: Interfaces UP?
  │   ├─ No → Interface/ISIS issue
  │   └─ Yes → Continue
  |
  ├─ ISIS: Adjacencies UP?
  │   ├─ No → Check isis enable, metric, authentication
  │   └─ Yes → Continue
  |
  ├─ MPLS: Node-SIDs present?
  │   ├─ No → Check node-segment configuration
  │   ├─ Conflict → Check for duplicate SIDs
  │   └─ Yes → Continue
  |
  ├─ BGP: Sessions Established?
  │   ├─ Idle/Active → Check neighbor config
  │   ├─ Established but no routes → Check policies
  │   └─ Established with routes → Continue
  |
  ├─ VPN Routes: Present in BGP table?
  │   ├─ No → Check RT export on remote PE
  │   ├─ Wrong RT → RT manipulation attack
  │   └─ Yes → Continue
  |
  ├─ VRF Routes: Installed in RIB?
  │   ├─ No → Check RT import
  │   └─ Yes → Continue
  |
  └─ Forwarding: Traffic reaching destination?
      ├─ Partial (small packets) → MTU issue
      ├─ One-way → ACL or return path issue
      └─ No → Label/next-hop issue
```

## Expert Attack Patterns

### Multi-Layer Attacks
**Symptoms**: Complete outage, basic checks look normal individually
**Approach**:
1. Check ISIS, MPLS, BGP independently
2. Each may have separate issue
3. ALL must be fixed to restore

**Key Commands**:
```
show isis interface brief
show isis segment-routing prefix-sids
show bgp summary
show bgp neighbors RR | include send-community
```

### Misdirection Attacks
**Symptoms**: Alarms on one device, problem elsewhere
**Approach**:
1. Don't trust the ticket completely
2. Check ALL related devices, not just mentioned ones
3. Look for subtle policy changes

**Key Commands**:
```
show ip access-lists
show route-map [NAME]
show running-config diff
```

### RT Manipulation
**Symptoms**: Routes missing or leaking between VRFs
**Approach**:
1. Verify RT import/export on both PE endpoints
2. Check for unexpected RT additions

**Key Commands**:
```
show vrf [VRF]
show running-config | section "vrf instance"
show bgp vpn-ipv4 all | include "Route Dist"
```

### Policy Corruption
**Symptoms**: Routes rejected or modified unexpectedly
**Approach**:
1. Check route-map sequences (deny before permit?)
2. Check prefix-list definitions
3. Check RCF functions (Arista-specific)

**Key Commands**:
```
show route-map CE[X]-IN
show ip prefix-list CE[X]-ALLOWED
show running-config | section control-functions
```

### SRGB/Label Issues
**Symptoms**: Intermittent failures on specific paths
**Approach**:
1. Check SRGB ranges on all P routers
2. Look for Node-SID conflicts

**Key Commands**:
```
show mpls label ranges
show segment-routing mpls sids
show isis segment-routing prefix-sids | grep "index [NUM]"
```

### MTU Black Holes
**Symptoms**: Small packets work, large fail
**Approach**:
1. Test with large pings
2. Check MTU on all interfaces in path

**Key Commands**:
```
ping [dest] size 1500 df-bit
show interfaces | include "Ethernet|mtu"
```

### Next-Hop Issues
**Symptoms**: Routes present, traffic black-holes
**Approach**:
1. Check next-hop-self on RRs
2. Verify next-hop reachability via ISIS

**Key Commands**:
```
show bgp vpn-ipv4 rd [RD] [prefix] detail
show bgp neighbors [RR] | include next-hop
```

### RCF Issues (Arista-specific)
**Symptoms**: Policy not working as expected
**Approach**:
1. Check if RCF is applied
2. Read RCF code - look for inverted logic

**Key Commands**:
```
show running-config | section control-functions
show bgp neighbors [X] | include rcf
```

## Verification Checklist

Before declaring FIXED:
- [ ] All 3 VRFs passing ping tests
- [ ] All ISIS adjacencies UP
- [ ] All BGP sessions Established
- [ ] No unexpected routes in any VRF
- [ ] Root cause documented
- [ ] Fix commands documented

## Common Mistakes to Avoid

1. **Trusting the NOC ticket** - It's designed to mislead
2. **Stopping at first fix** - Multi-layer attacks require ALL fixes
3. **Ignoring other VRFs** - Cross-VRF symptoms happen
4. **Not checking policies** - Route-maps and RCFs are common targets
5. **Using only ping** - Large packet tests needed for MTU issues
6. **Checking only affected PE** - Remote PE or core might be the problem

## Time Targets

| Difficulty | Expected Diagnosis Time |
|------------|------------------------|
| Medium-Hard | 2-3 minutes |
| Hard | 3-5 minutes |
| Expert | 5-10 minutes |
| Ultimate | 10-15 minutes |

## Final Tip

When stuck, ask yourself:
- "What would I NOT normally check?"
- "What looks normal but might be subtly wrong?"
- "Am I being misdirected?"

The expert attacks are designed to be where you don't look first.
