# Baseline Fixes Applied - 2026-01-15

## Issues Found and Fixed

### Issue 1: IP Routing Disabled
- **Symptom**: "Routing is not enabled" errors
- **Cause**: Default cEOS config has `no ip routing`
- **Fix**: Enabled IP routing on all 12 routers with `ip routing` and `ip routing vrf [VRF]`

### Issue 2: MPLS Routing Disabled  
- **Symptom**: VPN-IPv4 routes not being exported
- **Cause**: MPLS routing not enabled by default
- **Fix**: Enabled MPLS on all routers with `mpls ip`

### Issue 3: P2-P3 Subnet Mismatch
- **Symptom**: ISIS adjacency between P2-P3 not forming
- **Cause**: Baseline configs had mismatched subnets (P2 Et3: 10.2.2.0/31, P3 Et2: 10.1.3.1/31)
- **Fix**: Changed P3 Et2 to 10.2.2.1/31

### Issue 4: PE3-P2 Subnet Mismatch
- **Symptom**: PE3 couldn't reach any destination
- **Cause**: ContainerLab connects PE3:eth1 to P2:eth6, but configs had different subnets
- **Fix**: Changed P2 Et6 to 10.2.3.0/31 to match PE3 Et1 (10.2.3.1/31)

### Issue 5: RR Next-Hop-Self Breaking VPN Routes
- **Symptom**: RR showed routes advertised but PEs received 0
- **Cause**: `next-hop-self` on RR changes VPN route next-hop, breaking PE-specific VPN labels
- **Fix**: Removed `next-hop-self` from PE-CLIENTS peer group on both RRs

## Verification
All 3 VRFs now operational:
- VRF ALPHA: CE1 <-> CE4 - 0% loss
- VRF BETA: CE2 <-> CE5 - 0% loss  
- VRF GAMMA: CE3 <-> CE6 - 0% loss
