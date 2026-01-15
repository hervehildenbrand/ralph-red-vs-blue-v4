# Round 8 Attack Specification

## Attack ID: ML-E5 - Cross-VRF Symptom (Route Leak)

## Target
- **Device**: PE1
- **VRF**: ALPHA (leaking into BETA)
- **Difficulty**: Expert

## Objective

Create a route leak by adding BETA's route-target to ALPHA's export list. This causes ALPHA routes to leak into BETA VRF, creating unexpected routes and potential security/connectivity issues.

## Attack Commands

Apply on PE1:
```
configure terminal
vrf instance ALPHA
  route-target export 65000:200
exit
end
write memory
```

## Execution

Connect to PE1 via:
```bash
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'configure terminal
vrf instance ALPHA
route-target export 65000:200
exit
end
write memory'"
```

## Verification

After attack, verify route leak:
```bash
# Check ALPHA VRF route-targets
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'show vrf ALPHA'"

# Check if ALPHA routes appear in BETA
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe2 Cli -c 'show ip route vrf BETA'"

# Verify BETA VRF has unexpected routes
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce2 ping -c 3 192.168.5.2"
```

Expected result: **BETA customer seeing unexpected ALPHA routes**, potential connectivity issues.

## Success Criteria

- [ ] RT 65000:200 added to ALPHA export on PE1
- [ ] ALPHA routes leaking into BETA VRF
- [ ] BETA VRF showing unexpected routes
- [ ] Configuration saved

## NOC Ticket

> **Ticket #008**: BETA customer seeing unexpected routes, possible route leak.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
