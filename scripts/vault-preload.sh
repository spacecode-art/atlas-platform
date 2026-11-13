#!/usr/bin/env bash
# Load the pinned Vault image into the kind nodes. Safe to run again.
# Keep IMAGE in step with gitops/apps/vault.yaml and docs/adr/ADR-0007-*.
set -euo pipefail

CLUSTER=atlas-platform
IMAGE=hashicorp/vault:2.0.4

for tool in docker kind; do
  command -v "$tool" >/dev/null || { echo "missing tool: $tool" >&2; exit 1; }
done

docker image inspect "$IMAGE" >/dev/null 2>&1 || docker pull "$IMAGE"
kind load docker-image --name "$CLUSTER" "$IMAGE"
docker image inspect "$IMAGE" --format '{{range .RepoDigests}}{{.}}{{"\n"}}{{end}}'