# Changelog

All notable changes to this project are documented here. Format loosely
follows [Keep a Changelog](https://keepachangelog.com/).

## [Unreleased]

### 2026-11-12

- `feat(chart)`: `charts/atlas-app` 0.1.0 (non-root, read-only root
  filesystem, resource limits, PodDisruptionBudget, default-deny
  NetworkPolicy), ADR-0004. `scripts/chart-check.sh` runs helm lint,
  kubeconform (schema 1.37.0) and two negative tests; evidence in
  `docs/evidence/p6-2/`. Not deployed yet: `hello` still runs from plain
  manifests
- `ci`: secrets scan pinned to a commit SHA, `chart-check` job, Dependabot
  for actions
- `fix(gitops)`: resources finalizer on the `hello` Application. Prune test,
  one run each: without it, removing the app from Git left its Deployment
  and pods running; with it, they were deleted. Removing the last app is
  blocked by Argo CD's empty-sync guard. ADR-0005, ADR-0006, ADR-0003
  corrected. Evidence in `docs/evidence/p6-1/`
- `feat(gitops)`: `hello` now deploys from `charts/atlas-app` with inline
  values; the plain manifests in `gitops/workloads/hello` are removed. One
  run on the local kind cluster: pods run non-root with a read-only root
  filesystem; NetworkPolicy blocked ingress from another namespace and
  egress from the app, with controls reaching their targets. P6-2 done.
  Evidence in `docs/evidence/p6-2/`
- `docs(adr)`: ADR-0007 to ADR-0009 for P6-3 (Vault dev server in the cluster,
  Kubernetes auth for External Secrets, a script-based check that no secret
  value is in Git), accepted before any build

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
