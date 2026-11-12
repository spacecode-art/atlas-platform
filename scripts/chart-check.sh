#!/usr/bin/env bash
# Lint the atlas-app chart and validate every rendered manifest against the
# Kubernetes schemas. CI runs this same script.
# K8S_VERSION is the schema version to validate against; override it if the
# schemas for the cluster's version are not published yet, and record that.
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
CHART="$ROOT/charts/atlas-app"
K8S_VERSION="${K8S_VERSION:-1.37.0}"

for tool in helm kubeconform; do
  command -v "$tool" >/dev/null || { echo "missing tool: $tool" >&2; exit 1; }
done

shopt -s nullglob
values=("$CHART"/ci/*-values.yaml)
[ "${#values[@]}" -gt 0 ] || { echo "no ci/*-values.yaml found" >&2; exit 1; }

for v in "${values[@]}"; do
  echo "== $(basename "$v")"
  helm lint "$CHART" --strict -f "$v"
  helm template check "$CHART" -f "$v" \
    | kubeconform -strict -summary -kubernetes-version "$K8S_VERSION"
done

# Guards must keep failing, with the right message. Arguments: description,
# expected message, then extra helm args.
expect_fail() {
  local desc=$1 msg=$2 out
  shift 2
  if out=$(helm template check "$CHART" "$@" 2>&1); then
    echo "FAIL: $desc: rendered, but should have failed" >&2
    exit 1
  fi
  grep -qF "$msg" <<<"$out" || { echo "FAIL: $desc: wrong error: $out" >&2; exit 1; }
  echo "ok: $desc"
}

echo "== negative tests"
expect_fail "no image" "image.repository is required"
expect_fail "empty ingressFrom" "networkPolicy.ingressFrom must list at least one peer" \
  -f "$CHART/ci/default-values.yaml" --set networkPolicy.ingressFrom=null