# ADR-0006: Keep Argo CD's empty-sync guard on the root Application

## Status
Accepted 2026-11-12, after the prune test.

## Context
Removing the last Application from `gitops/apps/` does not remove its
workload. Two cases were observed:

- The directory stays (a `.gitkeep` is left in it). Root reported
  `OutOfSync`, and `hello` was not pruned. Argo CD's status contained
  `auto-sync will wipe out all resources`
  (`docs/evidence/p6-1/empty-apps-dir-blocks-prune.txt`, one run, only the
  last line of the message was captured).
- The directory disappears, because Git does not track empty directories.
  Root reported `gitops/apps: app path does not exist` and synced nothing.
  Seen in two runs; the output is not committed.

## Decision
Leave `allowEmpty` unset (false) on the root Application. Do not add a
placeholder file to keep the directory. Removing the last workload is a
deliberate manual step, not something a Git commit does silently.

## Alternatives and tradeoffs

| Option | Decision |
|---|---|
| Keep the guard | Chosen: a bad merge or a wrong path that empties `gitops/apps/` cannot wipe every workload. |
| `allowEmpty: true` on root | Rejected: removes exactly that protection to make one rare operation convenient. |
| Placeholder file to keep the directory | Not needed: the platform will always have at least one Application. |

## Boundaries and evidence
Observed on a local kind cluster, Argo CD chart 10.17.2 (v3.6.1). Deleting
the last Application by hand has not been tested here.