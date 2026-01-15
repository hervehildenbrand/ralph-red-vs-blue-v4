# Ralph Red vs Blue v4 - CCIE+ Expert Challenge

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![ContainerLab](https://img.shields.io/badge/ContainerLab-0.50+-blue.svg)](https://containerlab.dev)
[![Arista cEOS](https://img.shields.io/badge/Arista-cEOS%204.35.1F-blue.svg)](https://www.arista.com/en/products/eos)
[![Difficulty](https://img.shields.io/badge/Difficulty-CCIE%2B-red.svg)]()

**An expert-level AI-driven chaos engineering challenge for network troubleshooting masters.**

## What's New in v4

| Aspect | v3 | v4 |
|--------|----|----|
| Rounds | 50 | **15** |
| Difficulty | 90% basic attacks | **100% CCIE+ Expert** |
| Attack Types | 4 repeated | **All 10 categories** |
| Multi-Layer | 1 | **5** |
| Misdirection | 0 | **3** |
| Policy/RCF | 0 | **3** |
| Expected Blue Win | 100% | **~50%** |

## Forbidden Attacks (Used in v3 - Too Easy)

These attack types are **BANNED** in v4:
- Interface shutdown on CE-facing ports
- BGP neighbor shutdown
- Redistribute connected removal
- ISIS enable removal (alone)

## Attack Categories Used

| Category | Rounds | Example |
|----------|--------|---------|
| Multi-Layer | 1, 8, 15 | Triple-layer attack, Cross-VRF symptom |
| Misdirection | 2, 7, 12 | One-way ACL, Metric maze |
| SR-MPLS | 3, 13 | SRGB mismatch, Anycast SID conflict |
| Intermittent | 4, 11 | MTU black hole, Metric oscillation |
| Cross-VRF | 5 | Multi-VRF cascade |
| Policy | 6 | Route-map sequence swap |
| Traffic Eng | 9 | Next-hop-self removal |
| RCF | 10 | RCF logic inversion |
| IPv6 | 14 | Dual-stack asymmetry |

## Network Topology

```
                    +---------+     +---------+
                    |   RR1   |-----|   RR2   |
                    | 10.0.0.1|     |10.0.0.2 |
                    +----+----+     +----+----+
                         |               |
       +-----------------+-------+-------+-----------------+
       |                 |               |                 |
  +----+----+       +----+----+     +----+----+       +----+----+
  |   P1    |-------|   P2    |-----|   P3    |-------|   P4    |
  |10.0.0.11|       |10.0.0.12|     |10.0.0.13|       |10.0.0.14|
  +----+----+       +----+----+     +----+----+       +----+----+
       |                 |               |                 |
  +----+----+       +----+----+     +----+----+       +----+----+
  |   PE1   |       |   PE2   |     |   PE4   |       |   PE5   |
  |  ALPHA  |       |  BETA   |     |  ALPHA  |       |  BETA   |
  +----+----+       +----+----+     +----+----+       +----+----+
       |                 |               |                 |
  +----+----+       +----+----+     +----+----+       +----+----+
  |   CE1   |       |   CE2   |     |   CE4   |       |   CE5   |
  +----+----+       +----+----+     +----+----+       +----+----+
  192.168.1.x       192.168.2.x     192.168.4.x       192.168.5.x

  VRF ALPHA         VRF BETA        VRF ALPHA         VRF BETA
  RT: 65000:100     RT: 65000:200   RT: 65000:100     RT: 65000:200

  (PE3/CE3 and PE6/CE6 serve VRF GAMMA with RT 65000:300)
```

## RALPH + GAIT Framework

All operations follow the Iron Laws:
1. NO NETWORK CHANGES WITHOUT A GIT BRANCH
2. NO ACTIONS WITHOUT COMMITS
3. NO CHANGES WITHOUT VERIFICATION
4. NO COMPLETION WITHOUT SUMMARY

## Project Structure

```
ralph-red-vs-blue-v4/
├── topology/                  # Symlink to v3 topology
├── ralph-red/
│   ├── PROMPT.md              # Red agent instructions
│   └── expert-catalog.json    # 15 expert attacks
├── ralph-blue/
│   ├── PROMPT.md              # Blue agent instructions
│   └── diagnostic-playbook.md # Expert diagnostic guide
├── rounds/
│   └── round-01/ ... round-15/
│       ├── noc-ticket.md
│       ├── red-plan.md
│       ├── red-attack.log
│       ├── blue-diagnosis.log
│       ├── blue-resolution.md
│       ├── summary.md
│       └── evidence/
├── FINAL-REPORT.md
└── FINAL-REPORT.html
```

## Running the Challenge

### Prerequisites
- ContainerLab 0.50+ on remote server
- Arista cEOS 4.35.1F image
- SSH access to ContainerLab server

### Deploy Topology
```bash
ssh hhildenbrand@192.168.1.12
cd /path/to/lab
sudo clab deploy -t topology/red-vs-blue-v3.clab.yml
```

### Verify Connectivity
```bash
docker exec clab-red-vs-blue-v3-ce1 ping -c 5 192.168.4.2  # ALPHA
docker exec clab-red-vs-blue-v3-ce2 ping -c 5 192.168.5.2  # BETA
docker exec clab-red-vs-blue-v3-ce3 ping -c 5 192.168.6.2  # GAMMA
```

## Scoring

### Blue Points
| Achievement | Points |
|-------------|--------|
| Correct diagnosis first try | +30 |
| Fix in <3 minutes | +20 |
| Fix in 3-5 minutes | +15 |
| Minimal commands (<10) | +10 |
| Root cause fix | +20 |
| All components found | +15 |
| GAIT compliance | +5 |

### Red Points
| Achievement | Points |
|-------------|--------|
| Blue checks wrong layer | +5 |
| Blue checks wrong VRF | +10 |
| Multi-component attack | +10 |
| Diagnosis >5 min | +10 |
| Diagnosis >10 min | +20 |
| Blue applies wrong fix | +15 |
| Blue cannot fix | +30 |
| GAIT compliance | +5 |

## License

MIT License - See LICENSE for details.

## Acknowledgments

- Built using **RALPH + GAIT** autonomous network operations framework
- Powered by Claude AI agents
- Network virtualization by ContainerLab
- Router images by Arista Networks
