# ADR-0004: One generic Helm chart as the golden path

## Status
Accepted 2026-11-11, before the P6-2 chart.

## Context
P6-1 workloads are raw manifests. Every new application would copy them and
drift: one gets probes, another forgets the network policy. The README
promises that every workload gets the same probes, limits, disruption budget
and network policy.

## Decision
One chart, `charts/atlas-app`. Applications differ only by values. The chart
enforces: non-root, read-only root filesystem (writable `/tmp` emptyDir),
all capabilities dropped, seccomp RuntimeDefault, no service account token,
resource requests with a memory limit and no CPU limit, readiness and
liveness probes, a PodDisruptionBudget (`maxUnavailable: 1`), and a
NetworkPolicy that denies by default (DNS egress allowed, ingress listed
explicitly). There is no default image: `image.repository` and a tag or
digest are required. Selector labels are `app.kubernetes.io/name` only, so
the existing `hello` selector survives the move to the chart.

## Alternatives and tradeoffs

| Option | Decision |
|---|---|
| One generic chart | Chosen: guarantees live in one reviewed place. |
| Per-application charts | Drift is the problem being solved. |
| Kustomize base and overlays | Works, but cannot require inputs or fail on bad values. |
| Library chart with thin app charts | Right at many teams; premature for one workload. |

## Boundaries and evidence
`helm lint` and schema validation prove the manifests are well formed, not
that they are safe or enforced. A NetworkPolicy protects nothing unless the
CNI enforces it, so P6-2 includes a deny test on this cluster; if kind's CNI
does not enforce it, that becomes a finding and its own ADR. The chart is a
convention. Enforcement (Pod Security Admission, admission policy) is not
part of this milestone.