# ADR-0009: Prove "no secret value in Git" with a script that never prints the value

## Status
Accepted 2026-11-12, before the P6-3 build.

## Context
The P6-3 check is that a secret reaches the pod and no value is anywhere in
Git. Evidence files are committed, so a check that prints the value creates
the leak it is meant to rule out.

## Decision
`scripts/secrets-check.sh` generates a random value at run time, writes it to
Vault, waits for the Kubernetes Secret to appear, and compares the pod's
environment value with the original by SHA-256 digest. It prints only MATCH or
MISMATCH and a short digest prefix. It then searches the working tree and the
entire Git history for the exact value and expects zero hits, and confirms the
pod spec contains a reference to a Secret and no literal value. Its output is
the committed evidence.

## Alternatives and tradeoffs

| Option | Decision |
|---|---|
| Random value, digest comparison, history search | Chosen: the claim is tested against a value nobody chose, and nothing secret is printed. |
| Gitleaks alone | Pattern-based, so it would not recognise an arbitrary random string as a secret. Kept as a second line of defence in CI, not as proof. |
| Print the value to show it arrived | Rejected: the value lands in the evidence. |

## Boundaries and evidence
The value exists briefly in the script's memory and command line on the host,
which is acceptable for a random throwaway. The search covers this clone's
history, not other clones, forks or CI logs, and the script is not run in CI.
The pod receives the secret as an environment variable, as the README diagram
shows; environment variables are visible to anyone who can exec into the pod,
and mounted files are the alternative if that matters later.