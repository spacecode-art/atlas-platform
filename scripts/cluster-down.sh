#!/usr/bin/env bash
# Delete only the atlas-platform kind cluster. Other clusters are untouched.
set -euo pipefail
kind delete cluster --name atlas-platform
