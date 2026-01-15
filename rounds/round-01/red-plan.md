# Round 1: ML-E6 Triple-Layer Attack

## Attack Overview
**Target**: PE3 (GAMMA VRF)
**Difficulty**: ULTIMATE (CCIE+ Level)
**Expected Blue Time**: 5-10 minutes

## Attack Components

### Component 1: Remove ISIS from uplink
```
interface Ethernet1
  no isis enable CORE
```
**Effect**: PE3 loses IGP reachability but link stays up

### Component 2: Remove Node-SID
```
router isis CORE
  no segment-routing node-segment ipv4 index
```
**Effect**: No SR label for PE3 loopback, breaking MPLS forwarding

### Component 3: Break BGP extended community
```
router bgp 65000
  no neighbor RR send-community extended
```
**Effect**: VPN routes from PE3 lose RT, won't import at remote PEs

## Why This Is Hard

Blue must identify and fix ALL 3 issues:
1. ISIS removal breaks IGP - but interface shows UP
2. Node-SID removal breaks MPLS - labels appear absent
3. Extended community removal breaks VPN - routes disappear silently

Each component alone would cause partial failure. Together they create
complete outage with multiple layers of misdirection. Fixing only 1-2
will not restore service.

## Misdirection Elements

- Interface Ethernet1 shows "connected"
- BGP sessions may still show "Established" initially
- Other VRFs work normally
- NOC ticket only mentions "complete outage"
