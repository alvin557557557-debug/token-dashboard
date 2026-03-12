#!/usr/bin/env bash
set -euo pipefail

# Sync latest dashboard JSON into the GitHub data branch.
# Required env:
# - GITHUB_OWNER
# - GITHUB_REPO
# - GITHUB_TOKEN
# Optional env:
# - DATA_BRANCH (default: data)
# - WORKSPACE (default: /home/node/.openclaw/workspace)

: "${GITHUB_OWNER:?missing GITHUB_OWNER}"
: "${GITHUB_REPO:?missing GITHUB_REPO}"
: "${GITHUB_TOKEN:?missing GITHUB_TOKEN}"

DATA_BRANCH="${DATA_BRANCH:-data}"
WORKSPACE="${WORKSPACE:-/home/node/.openclaw/workspace}"
SRC="$WORKSPACE/token-audit/dashboard"
TMP="$(mktemp -d)"
REPO_URL="https://${GITHUB_OWNER}:${GITHUB_TOKEN}@github.com/${GITHUB_OWNER}/${GITHUB_REPO}.git"

cleanup() { rm -rf "$TMP"; }
trap cleanup EXIT

"$WORKSPACE/token-audit/refresh-dashboard.sh"

git clone --depth 1 --branch "$DATA_BRANCH" "$REPO_URL" "$TMP/repo" || {
  git clone --depth 1 "$REPO_URL" "$TMP/repo"
  cd "$TMP/repo"
  git checkout --orphan "$DATA_BRANCH"
  git rm -rf . >/dev/null 2>&1 || true
}

mkdir -p "$TMP/repo/dashboard"
rm -rf "$TMP/repo/dashboard"/*
cp -a "$SRC/." "$TMP/repo/dashboard/"

cd "$TMP/repo"
git config user.name "OpenClaw Bot"
git config user.email "openclaw-bot@users.noreply.github.com"
git add dashboard
if git diff --cached --quiet; then
  echo "No data changes"
  exit 0
fi
git commit -m "Update dashboard data $(date -u +%Y-%m-%dT%H:%M:%SZ)"
git push origin "$DATA_BRANCH"
