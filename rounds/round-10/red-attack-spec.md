# Round 10 Attack Specification

## Attack ID: RCF-E2 - RCF Logic Inversion

## Target
- **Device**: PE1
- **Component**: Router Control Functions (RCF)
- **Difficulty**: Expert

## Objective

Break ALPHA VRF by implementing a Router Control Function with inverted logic. The RCF will appear to be a normal policy but contains logic that denies instead of permits, causing routes to be rejected.

## Attack Commands

Apply on PE1:
```
configure terminal
router general
  control-functions
    code
    function BAD_LOGIC() {
      if community_list_match(community, "PERMIT_ALL") {
        return false;
      }
      return false;
    }
    EOF
exit
exit
router bgp 65000
  vrf ALPHA
    rcf in BAD_LOGIC()
exit
exit
end
write memory
```

## Execution

Connect to PE1 via:
```bash
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'configure terminal
router general
control-functions
code
function BAD_LOGIC() {
if community_list_match(community, \"PERMIT_ALL\") {
return false;
}
return false;
}
EOF
exit
exit
router bgp 65000
vrf ALPHA
rcf in BAD_LOGIC()
exit
exit
end
write memory'"
```

## Verification

After attack, verify RCF is blocking routes:
```bash
# Check RCF configuration
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'show running-config section control-functions'"

# Check BGP VRF routes
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-pe1 Cli -c 'show ip bgp vrf ALPHA'"

# Verify ALPHA broken
ssh hhildenbrand@192.168.1.12 "docker exec clab-red-vs-blue-v3-ce1 ping -c 3 192.168.4.2"
```

Expected result: **ALPHA VRF routes being rejected** by the RCF.

## Success Criteria

- [ ] BAD_LOGIC RCF function created
- [ ] RCF applied to ALPHA VRF BGP inbound
- [ ] ALPHA routes being rejected
- [ ] BETA and GAMMA VRFs remain operational
- [ ] Configuration saved

## NOC Ticket

> **Ticket #010**: ALPHA customer routes being rejected, policy may be misconfigured.

## Exit Signal

When attack is complete and verified, output:
```
EXIT_SIGNAL: true
```
