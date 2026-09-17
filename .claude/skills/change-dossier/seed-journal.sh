#!/usr/bin/env bash
# Seed a change-dossier decision journal in a git worktree.
#
# Two modes:
#   --path <dir>   library mode: seed <dir>, print nothing. Called by
#                  inject-journal.sh at SessionStart.
#   (stdin JSON)   hook mode: PostToolUse on Bash, for a manual
#                  `git worktree add`. Prints JSON.
#
# NOT wired to WorktreeCreate. That event's contract is to print the absolute
# path where the worktree should be created — the harness consumes its stdout
# as the location — so a hook that prints anything else fails the event, and
# one that prints a path would relocate the user's worktrees. It also fires
# before the worktree exists, so there is nothing to seed at that point.

set -uo pipefail

seed() {
  local WT="$1" GD GC DIR JOURNAL BRANCH EXCL
  [ -n "$WT" ] && [ -d "$WT" ] || { echo unresolved; return 1; }

  GD=$(git -C "$WT" rev-parse --git-dir 2>/dev/null) || { echo not-a-repo; return 1; }
  GC=$(git -C "$WT" rev-parse --git-common-dir 2>/dev/null) || { echo not-a-repo; return 1; }
  GD=$(cd "$GD" 2>/dev/null && pwd -P) || { echo not-a-repo; return 1; }
  GC=$(cd "$GC" 2>/dev/null && pwd -P) || { echo not-a-repo; return 1; }
  # Only linked worktrees are units of work; the main checkout is not.
  [ "$GD" != "$GC" ] || { echo main-checkout; return 1; }

  DIR="$WT/docs/change-dossiers"; JOURNAL="$DIR/JOURNAL.md"
  [ -e "$JOURNAL" ] && { echo already-open; return 1; }
  mkdir -p "$DIR" 2>/dev/null || { echo mkdir-failed; return 1; }

  BRANCH=$(git -C "$WT" branch --show-current 2>/dev/null)
  [ -n "$BRANCH" ] || BRANCH="(detached HEAD)"

  cat >"$JOURNAL" <<EOF
# Decision journal — $BRANCH

Opened $(date -u +%Y-%m-%d) by the change-dossier hook. One line per decision, appended when the decision is made: the choice, an em dash, then what the choice was responsive to.

Log a decision whose answer to "what is this responsive to?" is not one of: the user said so, the codebase does it this way here, this is the industry convention. An unchecked copy from a neighbouring file or an earlier branch does not count as the second answer.

At wrap-up, invoke the change-dossier skill. It reads this file, decides whether the change has earned a dossier, and deletes this file either way.

EOF

  # git honors info/exclude from the common git dir only — a copy in the
  # per-worktree gitdir is ignored (verified on git 2.50) — so one entry
  # covers every worktree of this repository and nothing is committed.
  EXCL="$GC/info/exclude"
  mkdir -p "$GC/info" 2>/dev/null
  grep -qxF 'docs/change-dossiers/' "$EXCL" 2>/dev/null \
    || printf 'docs/change-dossiers/\n' >>"$EXCL" 2>/dev/null || true

  printf 'seeded\t%s' "$BRANCH"
  return 0
}

log() { printf '%s\t%s\t%s\t%s\n' "$(date -u +%FT%TZ)" "$1" "$2" "$3" \
          >>"${HOME}/.claude/change-dossier-hook.log" 2>/dev/null || true; }

# --- library mode -----------------------------------------------------------
if [ "${1:-}" = "--path" ]; then
  R=$(seed "${2:-}") || true
  log SessionStart "${R%%$'\t'*}" "${2:-}"
  exit 0
fi

# --- hook mode: PostToolUse on Bash ----------------------------------------
PAYLOAD=$(cat 2>/dev/null || true)
jq_get() { printf '%s' "$PAYLOAD" | jq -r "$1 // empty" 2>/dev/null; }
emit_noop() { printf '{"continue":true,"suppressOutput":true}\n'; exit 0; }

# Fires on every Bash call; screen the command here because the `if` permission
# filter in settings.json did not actually filter.
case "$(jq_get '.tool_input.command')" in
  *"git worktree add"*) ;;
  *) emit_noop ;;
esac

CWD=$(jq_get '.cwd'); [ -n "$CWD" ] && [ -d "$CWD" ] && cd "$CWD" 2>/dev/null

# Newest linked worktree by the mtime of its .git pointer file. Safe here,
# unlike at WorktreeCreate time, because `git worktree add` has already run.
WT=$(git worktree list --porcelain 2>/dev/null \
      | sed -n 's/^worktree //p' \
      | while IFS= read -r d; do
          [ -f "$d/.git" ] || continue
          printf '%s\t%s\n' "$(stat -f %m "$d/.git" 2>/dev/null || echo 0)" "$d"
        done \
      | sort -rn | head -1 | cut -f2-)

R=$(seed "$WT") || true
log PostToolUse "${R%%$'\t'*}" "${WT:-none}"
case "$R" in
  seeded*) jq -nc --arg m "Decision journal opened for ${R#*$'\t'} — append decisions as you make them; run /change-dossier at wrap-up." \
             '{continue:true,systemMessage:$m}' ;;
  *) emit_noop ;;
esac
