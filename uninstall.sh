#!/usr/bin/env bash
# Galaxy Maps — uninstall any installed bundle.
#
# Usage:
#   bash uninstall.sh                # remove all Galaxy Maps skills from ~/.claude/skills/
#   bash uninstall.sh --project      # remove from ./.claude/skills/
#   bash uninstall.sh --dest <dir>   # custom source

set -euo pipefail

ALL_REPOS=(
  gm-agent-01-orchestrator
  gm-agent-01a-orchestrator-with-agent-teams
  gm-agent-02-intent
  gm-agent-03-curriculum
  gm-agent-03a-curriculum-with-agent-teams
  gm-agent-04-curriculum-critiquer
  gm-agent-04a-curriculum-critiquer-with-agent-teams
  gm-agent-05-branching
  gm-agent-05a-branching-with-agent-teams
  gm-agent-06-mission-builder
  gm-agent-06a-mission-builder-with-agent-teams
  gm-agent-07-mission-critiquer
  gm-agent-07a-mission-critiquer-with-agent-teams
)

DEST="${HOME}/.claude/skills"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) DEST="$(pwd)/.claude/skills"; shift ;;
    --dest)    DEST="$2"; shift 2 ;;
    -h|--help) sed -n '2,7p' "$0"; exit 0 ;;
    *)         echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

removed=0
for repo in "${ALL_REPOS[@]}"; do
  target="$DEST/$repo"
  if [ -d "$target" ]; then
    echo "  - removing $repo"
    rm -rf "$target"
    removed=$((removed + 1))
  fi
done

echo ""
echo "Removed $removed Galaxy Maps skill(s) from $DEST"
