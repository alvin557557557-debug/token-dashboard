#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
ENV_FILE="$REPO_ROOT/.sync.env"

if [[ ! -f "$ENV_FILE" ]]; then
  echo "Missing $ENV_FILE" >&2
  echo "Create it with GITHUB_OWNER, GITHUB_REPO, GITHUB_TOKEN, DATA_BRANCH, WORKSPACE" >&2
  exit 1
fi

set -a
# shellcheck disable=SC1090
source "$ENV_FILE"
set +a

cd "$REPO_ROOT"
exec ./scripts/sync-data.sh
