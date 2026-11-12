# ADR-0005: Child Applications carry the resources finalizer

## Status
Accepted 2026-11-12, after the prune test. Corrects a claim in ADR-0003.

## Context
ADR-0003 said a manifest removed from Git removes the workload. That was
written before it was tested. The root Application had the resources
finalizer; the child `hello` Application did not.

The test pointed the root Application at a throwaway branch that removed
`gitops/apps/hello.yaml` and added a second Application, so the root stayed
non-empty (see ADR-0006). Root pruned the `hello` Application, but the
`hello` Deployment and both pods kept running, with the same pod names and the
same 21h age as before (`docs/evidence/p6-1/prune-before-finalizer.txt`). The
throwaway second Application, which also had no finalizer, left its workload
behind in both runs; that output was read from the terminal and is not
committed.

## Decision
Every Application under `gitops/apps/` sets
`finalizers: [resources-finalizer.argocd.argoproj.io]`. With it on `hello`, the
same test removed the Application and its workload: the `hello` namespace
reported `No resources found`
(`docs/evidence/p6-1/prune-after-finalizer.txt`). The namespace itself
remained.

## Alternatives and tradeoffs

| Option | Decision |
|---|---|
| Finalizer on every child Application | Chosen: removing an app from Git removes what it deployed. |
| No finalizer, delete leftovers by hand | Rejected: orphans keep running with no owner, and Argo CD no longer reports them. |

## Boundaries and evidence
One run each, on a local kind cluster, Argo CD chart 10.17.2 (v3.6.1). The
rule is enforced by review only; a CI check is not built yet. Cascade
deletion also removes anything stateful an app owns, which is acceptable for
this lab and would need a deliberate policy before real data lives here.