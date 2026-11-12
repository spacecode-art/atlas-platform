# ADR-0007: Vault dev server in the cluster, deployed by Argo CD

## Status
Accepted 2026-11-12, before the P6-3 build.

## Context
P6-3 needs a secrets store that External Secrets can read from, and the check
is that a secret reaches a pod while no value appears anywhere in Git. The
store has to come up with the cluster and be reproducible from this repository.

## Decision
Run Vault in dev mode inside the cluster, in namespace `vault`, as an Argo CD
Application in `gitops/apps/` from a pinned Helm chart. The chart version and
image tags are pinned when first installed and recorded in the milestone's
evidence. Images are pulled on the host and loaded into the nodes first, as in
`scripts/argocd-up.sh`. Dev mode keeps data in memory, so a seed script writes
the secrets after every start; a secret value is generated when the script
runs and is never stored in Git.

## Alternatives and tradeoffs

| Option | Decision |
|---|---|
| Vault in the cluster, dev mode | Chosen: reachable by Service DNS, same GitOps flow as everything else, rebuilt with the cluster. |
| Vault on the host in Docker | The kind nodes must reach a host address that differs by OS and Docker setup, and it adds a second lifecycle to manage. |
| OpenBao in the cluster | An open-source, API-compatible alternative and a possible later swap. Vault is kept because the roadmap names it. |
| Kubernetes Secrets applied by hand | No store and no reference pattern, which skips what this phase exists to show. |

## Boundaries and evidence
Dev mode is single pod, in-memory, auto-unsealed, plain HTTP inside the
cluster, with a well-known root token. It demonstrates the pattern and is not a
model of a production Vault. The dev root token is a throwaway constant for an
empty server; it is outside the "no value in Git" check, which concerns
application secrets. A restart loses every secret until the seed script is run
again.