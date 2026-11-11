# ADR-0001: Local kind cluster as the platform

## Status
Accepted 2026-11-11, before any implementation.

## Context
Phase 6 of the Atlas Path covers GitOps with ArgoCD, Helm charts, a
one-command "golden path" deploy and a secrets pattern. That work happens at
the Kubernetes API level and is the same on a local cluster as on EKS. An
always-on cloud cluster adds cost and no extra evidence for this phase.
`atlas-resilience` already runs a three-zone kind cluster, so the tooling and
the workload are familiar.

## Decision
Build and test everything on a local kind cluster. Use a Vault dev server for
the secrets pattern. A single optional recorded deployment to real EKS may
follow at the end to show portability. It is not a prerequisite, and it needs
its own cost and teardown design first.

## Alternatives and tradeoffs

| Environment | Decision |
|---|---|
| Local kind | Chosen: free, resettable, same Kubernetes API. |
| k3d or minikube | Equivalent for this purpose; kind is kept for continuity with `atlas-resilience`. |
| Live EKS | Optional later demo only; control plane cost and teardown risk. |

## Boundaries and evidence
A local cluster proves the automation and manifests work against the
Kubernetes API. It does not prove cloud IAM, load balancer, storage-class or
node-group behavior. Every result in this repository states that it came from
a local cluster, with its run count. Vault in dev mode keeps data in memory
and uses a fixed root token, so it demonstrates the secrets pattern and is not
a model of a production Vault.
