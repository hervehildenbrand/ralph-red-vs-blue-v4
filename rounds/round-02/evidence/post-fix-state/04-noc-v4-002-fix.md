# NOC-V4-002 Fix - 2026-01-15T06:01:06Z

## Root Cause
ACL `BLOCK-RETURN` applied inbound on PE2 Ethernet3 (VRF BETA PE-CE interface).

```
ip access-list BLOCK-RETURN
   10 deny ip any 192.168.5.0/24   <-- Blocks traffic to CE5!
   20 permit ip any any
```

Applied on:
```
interface Ethernet3
   ip access-group BLOCK-RETURN in
```

## Fix Applied
```
configure
interface Ethernet3
  no ip access-group BLOCK-RETURN in
end
```

## Verification
| VRF | Test | Result |
|-----|------|--------|
| ALPHA | CE1→CE4 | 0% loss ✅ |
| BETA | CE2→CE5 | 0% loss ✅ |
| GAMMA | CE3→CE6 | 0% loss ✅ |
