# ADR-0002: Install Argo CD from a pinned Helm chart

## Status
Accepted 2026-11-11, before the P6-1 install.

## Context
P6-1 needs a GitOps controller on the local kind cluster. Everything it
manages is described in this repository, and it pulls from it. The same chart
tooling is used for the workload chart in P6-2.

## Decision
Install the `argo/argo-cd` Helm chart, version 10.17.2 (Argo CD v3.6.1), from
`https://argoproj.github.io/argo-helm` into the `argocd` namespace. Settings
live in `bootstrap/argocd-values.yaml`. The chart accepts Kubernetes
`>=1.25.0-0`; the cluster runs v1.37.0. Upgrades are deliberate: change the
pinned version, reinstall, record the evidence.

The repository is public, so Argo CD reads it over HTTPS without credentials.
No deploy key or token is stored in the cluster.

## Alternatives and tradeoffs

| Option | Decision |
|---|---|
| Helm chart, pinned | Chosen: settings are a reviewable values file, and it matches the chart tooling used in P6-2. |
| Upstream `install.yaml` | Also pinnable, but changing a setting means patching raw manifests. |
| Kustomize over upstream manifests | Works, but adds a second templating tool for no gain in this phase. |

Helm hides the rendered manifests behind templates. `helm template` renders
them when they need inspecting.

## Boundaries and evidence
This is a single-user local lab install: no high availability, no SSO, no
repository credentials, and the UI is reached over plain HTTP through a
port-forward. It demonstrates the GitOps flow. It does not show production
hardening such as RBAC design, SSO, HA or credential rotation.
