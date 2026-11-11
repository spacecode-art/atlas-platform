#!/usr/bin/env bash
# Create the atlas-platform kind cluster and wait for every node to be Ready.
set -euo pipefail

CLUSTER=atlas-platform
CTX="kind-${CLUSTER}"
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

for tool in docker kind kubectl; do
  command -v "$tool" >/dev/null || { echo "missing tool: $tool" >&2; exit 1; }
done

if kind get clusters | grep -qx "$CLUSTER"; then
  echo "cluster $CLUSTER already exists; run scripts/cluster-down.sh first" >&2
  exit 1
fi

kind create cluster --config "$ROOT/cluster/kind-config.yaml"
kubectl --context "$CTX" wait --for=condition=Ready node --all --timeout=180s
kubectl --context "$CTX" get nodes -o wide
echo "cluster $CLUSTER ready in ${SECONDS}s"
