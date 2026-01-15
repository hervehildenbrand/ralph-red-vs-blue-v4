# Evidence Summary

- **Round**: 1
- **Phase**: post-attack
- **Captured**: 2026-01-15T05:38:41Z

## Files

| File | Description |
|------|-------------|
| connectivity.txt | VRF ping tests (CE to CE) |
| isis-adjacencies.txt | ISIS neighbor state on all PEs |
| bgp-summary.txt | BGP session state on all PEs |
| mpls-lfib.txt | MPLS label forwarding tables |
| vrf-routes.txt | VRF routing tables |

## Quick Analysis

```
=== VRF ALPHA (CE1 -> CE4) ===
3 packets transmitted, 3 packets received, 0% packet loss
=== VRF BETA (CE2 -> CE5) ===
3 packets transmitted, 3 packets received, 0% packet loss
=== VRF GAMMA (CE3 -> CE6) ===
3 packets transmitted, 0 packets received, 100% packet loss
```
