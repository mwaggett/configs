#!/usr/bin/env bash
# SessionStart hook. Two jobs, in order:
#   1. Seed a decision journal if this session's worktree has none. This is
#      where seeding belongs: WorktreeCreate fires before the worktree exists
#      and owns its stdout, whereas by SessionStart the worktree is real.
#   2. Put the journal into the model's context. Without this the file has no
#      effect at all — a file's existence is not visible to the model, so the
#      journal would stay empty until someone named it.
#
# Always prints a SessionStart-shaped JSON object: a hook that produces no
# output is reported as a failed hook, and the no-journal case is most sessions.

set -uo pipefail

PAYLOAD=$(cat 2>/dev/null || true)
SEEDER="${HOME}/.claude/skills/change-dossier/seed-journal.sh"

emit() {  # emit <context-string>; empty string injects nothing
  jq -n --arg ctx "$1" \
    '{hookSpecificOutput:{hookEventName:"SessionStart",additionalContext:$ctx}}'
  exit 0
}

# Prefer the payload's cwd: the hook's own working directory is not guaranteed
# to be the session's.
C=$(printf '%s' "$PAYLOAD" | jq -r '.cwd // empty' 2>/dev/null)
[ -n "$C" ] && [ -d "$C" ] && cd "$C" 2>/dev/null

ROOT=$(git rev-parse --show-toplevel 2>/dev/null) || emit ""
JOURNAL="$ROOT/docs/change-dossiers/JOURNAL.md"

# Seed on first session in a fresh worktree. The seeder is a no-op unless
# $ROOT is a linked worktree without a journal.
[ -f "$JOURNAL" ] || [ ! -x "$SEEDER" ] || "$SEEDER" --path "$ROOT" >/dev/null 2>&1
[ -f "$JOURNAL" ] || emit ""

BRANCH=$(git branch --show-current 2>/dev/null)
[ -n "$BRANCH" ] || BRANCH="(detached HEAD)"

# Inject the contents, not just the path. After a compaction this is the only
# surviving copy of the decisions logged so far, which is why the hook's
# matcher includes `compact`.
BODY=$(tail -c 6000 "$JOURNAL" 2>/dev/null) || BODY=""

emit "$(cat <<EOF
An open change-dossier decision journal exists for this worktree, at
$JOURNAL (branch: $BRANCH).

Append one line per decision at the moment you make it — the choice, an em
dash, then what the choice was responsive to. Fold the append into a Bash
call you were already making rather than spending a turn on it:

  printf '%s\n' 'retry count 3 — matches the existing Sidekiq default' >> '$JOURNAL'

Log a decision when its answer to "what is this responsive to?" is not one
of: the user said so, the codebase does it this way here, this is the
industry convention. Copying a value from a neighbouring file or an earlier
branch does not count as the second answer unless you checked that the
reason it holds there also holds here.

Do not batch these at the end. At wrap-up you hold a finished diff in which
a constant you copied and a constant you deliberated read identically, so
recall drops the decisions that felt automatic — which are most of them.

When the work is wrapping up, invoke the change-dossier skill. It reads this
journal, decides whether the change has earned a dossier, and deletes the
journal either way.

Journal contents so far:
--8<--
$BODY
--8<--
EOF
)"
