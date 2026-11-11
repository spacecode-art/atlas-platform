# Changelog

All notable changes to this project are documented here. Format loosely
follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### 2026-11-11

- `docs`: repository started for Phase 6 (Platform Engineering): README,
  contributing guide, license, editor config, ignore rules
- `docs(adr)`: ADR-0001 (local kind cluster as the platform), accepted
  before any build
- `ci`: secrets scan via `atlas-security`'s reusable workflow
- `feat(cluster)`: P6-0 kind cluster `atlas-platform` (one control plane, two
  workers, node image pinned by digest) with `cluster-up.sh` and
  `cluster-down.sh`. Two local runs: 116 s and 89 s to all nodes Ready. Evidence
  in `docs/evidence/p6-0/`
