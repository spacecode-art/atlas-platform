#!/usr/bin/env bash
# Install Argo CD on the atlas-platform cluster. Safe to run again.
# Images are pulled on the host and loaded into the nodes first, because
# pulling inside the cluster can exceed Helm's timeout on a slow connection.
# Keep CHART_VERSION and IMAGES in step with docs/adr/ADR-0002-*.
set -euo pipefail

CLUSTER=atlas-platform
CTX="kind-${CLUSTER}"
CHART_VERSION=10.17.2
IMAGES=(
  quay.io/argoproj/argocd:v3.6.1
  ecr-public.aws.com/docker/library/redis:8.6.4-alpine
)
ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl --context "$CTX" cluster-info >/dev/null \
  || { echo "cluster not reachable; run scripts/cluster-up.sh first" >&2; exit 1; }

for img in "${IMAGES[@]}"; do
  docker image inspect "$img" >/dev/null 2>&1 || docker pull "$img"
done
kind load docker-image --name "$CLUSTER" "${IMAGES[@]}"

helm repo add argo https://argoproj.github.io/argo-helm --force-update >/dev/null
helm upgrade --install argocd argo/argo-cd \
  --version "$CHART_VERSION" \
  --namespace argocd --create-namespace \
  --kube-context "$CTX" \
  -f "$ROOT/bootstrap/argocd-values.yaml" \
  --wait --timeout 10m

kubectl --context "$CTX" -n argocd get pods
echo "argocd ready in ${SECONDS}s"
