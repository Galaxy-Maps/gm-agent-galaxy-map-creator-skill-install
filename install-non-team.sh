#!/usr/bin/env bash
# Galaxy Maps — install the **non-team** skill bundle (8 skills)
#
# Usage:
#   bash install-non-team.sh                # personal install → ~/.claude/skills/
#   bash install-non-team.sh --project      # project install → ./.claude/skills/
#   bash install-non-team.sh --dest <dir>   # custom destination
#
# Or via curl (no clone needed):
#   curl -fsSL https://raw.githubusercontent.com/Galaxy-Maps/gm-agent-galaxy-map-creator-skill-install/main/install-non-team.sh | bash
#
# The script is idempotent — re-running it pulls latest on already-installed repos.

set -euo pipefail

ORG=Galaxy-Maps
BUNDLE_NAME="non-team"
REPOS=(
  gm-agent-01-orchestrator
  gm-agent-02-intent
  gm-agent-03-curriculum
  gm-agent-04-curriculum-critiquer
  gm-agent-05-branching
  gm-agent-06-mission-builder
  gm-agent-06a-youtube-scout
  gm-agent-07-mission-critiquer
)

# --- arg parsing -------------------------------------------------------------
DEST="${HOME}/.claude/skills"
while [[ $# -gt 0 ]]; do
  case "$1" in
    --project) DEST="$(pwd)/.claude/skills"; shift ;;
    --dest)    DEST="$2"; shift 2 ;;
    -h|--help) sed -n '2,12p' "$0"; exit 0 ;;
    *)         echo "Unknown arg: $1" >&2; exit 2 ;;
  esac
done

# --- preflight ---------------------------------------------------------------
command -v git >/dev/null 2>&1 || { echo "✗ git is required but not found in PATH" >&2; exit 1; }
mkdir -p "$DEST"

echo "Galaxy Maps — installing $BUNDLE_NAME bundle (${#REPOS[@]} skills)"
echo "Destination: $DEST"
echo ""

# --- install loop ------------------------------------------------------------
installed=0
updated=0
failed=()
for repo in "${REPOS[@]}"; do
  target="$DEST/$repo"
  url="https://github.com/$ORG/$repo.git"
  if [ -d "$target/.git" ]; then
    printf "  ↻ updating  %s\n" "$repo"
    if (cd "$target" && git pull --quiet --ff-only); then
      updated=$((updated + 1))
    else
      failed+=("$repo (pull failed)")
    fi
  elif [ -e "$target" ]; then
    echo "  ✗ $target exists but is not a git repo — skipping"
    failed+=("$repo (target not a git repo)")
  else
    printf "  ↓ cloning   %s\n" "$repo"
    if git clone --quiet --depth 1 "$url" "$target"; then
      installed=$((installed + 1))
    else
      failed+=("$repo (clone failed)")
    fi
  fi
done

echo ""
echo "Done — $installed new install(s), $updated update(s)."
if [ ${#failed[@]} -gt 0 ]; then
  echo ""
  echo "Failures:"
  for f in "${failed[@]}"; do echo "  - $f"; done
  exit 1
fi

echo ""
echo "Next: in Claude Code, type /gm-agent-01-orchestrator to start a Galaxy Map."
