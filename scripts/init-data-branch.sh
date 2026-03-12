#!/usr/bin/env bash
set -euo pipefail

# Initialize a local data-branch working tree with sample dashboard JSON.
# Usage:
#   scripts/init-data-branch.sh /path/to/clone
# Example:
#   git clone <repo-url> /tmp/token-dashboard-data
#   cd /tmp/token-dashboard-data && git checkout --orphan data
#   /path/to/repo/scripts/init-data-branch.sh /tmp/token-dashboard-data

TARGET_DIR="${1:-}"
if [[ -z "$TARGET_DIR" ]]; then
  echo "Usage: $0 /path/to/data-branch-working-tree" >&2
  exit 1
fi

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/.." && pwd)"
SAMPLE_DIR="$REPO_ROOT/data-sample"
TARGET_DASHBOARD_DIR="$TARGET_DIR/dashboard"

mkdir -p "$TARGET_DASHBOARD_DIR"
cp -a "$SAMPLE_DIR/." "$TARGET_DASHBOARD_DIR/"

echo "Initialized $TARGET_DASHBOARD_DIR with sample dashboard JSON"
