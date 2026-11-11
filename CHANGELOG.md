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
- `docs(adr)`: ADR-0002 (Argo CD from a pinned Helm chart) and ADR-0003
  (app-of-apps layout)
- `feat(gitops)`: P6-1 Argo CD 3.6.1 (chart 10.17.2) with a root Application
  and a placeholder `hello` workload. Both apps Synced and Healthy. A manual
  scale to 5 replicas was reverted within 10 s; a replica change pushed through
  Git was applied with no `kubectl` change. One local run each. Evidence in
  `docs/evidence/p6-1/`
- `feat(bootstrap)`: `scripts/argocd-up.sh` pulls the images on the host and
  loads them into the nodes before installing, since pulls inside the cluster
  exceeded Helm's timeout on a slow connection
