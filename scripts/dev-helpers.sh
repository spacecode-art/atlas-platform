# Source this file, do not execute it:  source scripts/dev-helpers.sh
# Helpers for the atlas-platform cluster and its Argo CD root Application.

k() { kubectl --context kind-atlas-platform "$@"; }

# Point the root Application at a branch (or back at main) and force a refresh.
point_root() {
  k -n argocd patch application root --type merge \
    -p "{\"spec\":{\"source\":{\"targetRevision\":\"$1\"}}}"
  k -n argocd annotate application root argocd.argoproj.io/refresh=hard --overwrite
}

# Wait up to 3 minutes for root to sync a given commit SHA.
wait_rev() {
  local r i
  for i in $(seq 1 36); do
    r=$(k -n argocd get application root -o jsonpath='{.status.sync.revision}')
    [ "$r" = "$1" ] && return 0
    sleep 5
  done
  echo "root never reached $1; last revision: '$r'" >&2
  k -n argocd get application root -o jsonpath='{.status.conditions[*].message}'; echo
  return 1
}