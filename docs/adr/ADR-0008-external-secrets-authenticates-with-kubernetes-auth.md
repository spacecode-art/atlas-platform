# ADR-0008: External Secrets authenticates to Vault with Kubernetes auth

## Status
Accepted 2026-11-12, before the P6-3 build.

## Context
External Secrets Operator needs a credential to read from Vault. Whatever it
is has to be created somewhere, and the pattern should not leave a long-lived
secret behind to protect the secrets.

## Decision
Enable Vault's Kubernetes auth method. A Vault role is bound to the External
Secrets service account in its own namespace, with a read-only policy limited
to one path prefix. External Secrets exchanges its service account token for a
short-lived Vault token. One `ClusterSecretStore` named `vault` points at
Vault, and a workload requests a secret with an `ExternalSecret` that names a
Vault path, never a value.

## Alternatives and tradeoffs

| Option | Decision |
|---|---|
| Kubernetes auth with a read-only policy | Chosen: no static credential, tokens are short-lived, access is limited by policy. |
| Static token in a Kubernetes Secret | A long-lived credential created out of band and stored in etcd, which is the pattern this phase should avoid. |
| AppRole | Needs a secret ID delivered to the operator, which is the same bootstrap problem again. |

## Boundaries and evidence
A cluster-wide store means any namespace can create an `ExternalSecret` that
reads whatever the Vault policy allows. That is acceptable for a single-tenant
lab; a multi-tenant platform needs one store per namespace. One run on a local
kind cluster, Vault in dev mode.