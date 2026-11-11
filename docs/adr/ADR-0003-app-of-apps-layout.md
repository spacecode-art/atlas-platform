# ADR-0003: App-of-apps layout for GitOps

## Status
Accepted 2026-11-11, before the P6-1 GitOps files.

## Context
Argo CD needs to be told what to deploy. Applying one Application per workload
by hand leaves the cluster state in shell history, which is what GitOps is
meant to avoid. We want one manual step and everything else driven from Git.

## Decision
One root Application, `bootstrap/root-app.yaml`, applied once with `kubectl`.
It watches `gitops/apps/` on `main`. Each file there is an Application for one
workload. Workloads sync from `gitops/workloads/<name>/` as plain manifests in
P6-1. From P6-2 they sync from `charts/atlas-app` with per-environment values.
Automated sync is on, with prune and self-heal, so Git is the source of truth:
a change made by hand in the cluster is reverted, and a manifest removed from
Git removes the workload.

The repository is public, so Argo CD reads it without credentials.

## Alternatives and tradeoffs

| Option | Decision |
|---|---|
| App-of-apps (root Application) | Chosen: one manual step, easy to read, no extra concepts. |
| ApplicationSet with generators | Better for many similar apps; adds a concept this phase does not need yet. |
| One Application per workload, applied by hand | No single entry point; cluster state lives in shell history. |

## Boundaries and evidence
Applying the root Application is the one step that is not driven by Git. Prune
and self-heal are safe in a lab and would need review before use anywhere with
data worth keeping. The P6-1 workload is a placeholder web server that proves
the sync loop. It is not the application platform; that is P6-2 onward.
