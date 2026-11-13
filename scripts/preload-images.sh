#!/usr/bin/env bash
# Load the pinned images of the Argo CD-managed platform apps into the kind
# nodes. Safe to run again. Keep IMAGES in step with gitops/apps/*.yaml and
# docs/adr/ADR-0007-*.
set -euo pipefail

CLUSTER=atlas-platform
IMAGES=(
  hashicorp/vault:2.0.4
  ghcr.io/external-secrets/external-secrets:v2.15.0
)

for tool in docker kind; do
  command -v "$tool" >/dev/null || { echo "missing tool: $tool" >&2; exit 1; }
done

for img in "${IMAGES[@]}"; do
  docker image inspect "$img" >/dev/null 2>&1 || docker pull "$img"
done
kind load docker-image --name "$CLUSTER" "${IMAGES[@]}"
for img in "${IMAGES[@]}"; do
  echo "$img"
  docker image inspect "$img" --format '{{range .RepoDigests}}  {{.}}{{"\n"}}{{end}}'
done