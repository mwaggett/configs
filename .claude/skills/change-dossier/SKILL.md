---
name: change-dossier
description: Produce a change dossier — a document recording what a change does, the inputs and data that motivated it, the assumptions and decisions the code does not record, the evidence that the approach is right, and how it was tested. Maintain a decision journal while the work happens, then decide at wrap-up whether the change has earned a dossier and assemble it. Invoke when finishing a branch, preparing a change for review, or when asked to write up, document, or justify a change; also invoke at the start of substantial work to open the journal.
---

# Change dossier

A dossier records what did not survive serialization into code: the
claims about the world a change encodes, the evidence for them, and
the decisions they drove. Behavior needs no recording, because any
reader parses the diff, or asks a model to explain it, and gets an
answer generated from the code as it currently stands. Intent needs
recording, because a deliberate precondition and a latent bug
serialize to identical code. So the dossier carries claims,
evidence, and decisions, and it never narrates mechanism the diff
already carries.

It serves two readers. The reviewer reads the top of it now and
decides whether to approve. The maintainer arrives months later and
reads deep for one answer: why is it like this? Ordering serves the
first reader and completeness serves the second, so front-load the
document and let it run long, because length past the first screen
is the reviewer's choice rather than the reviewer's obligation.

## The journal comes first

A worktree gets a journal at `docs/change-dossiers/JOURNAL.md`,
seeded by the `SessionStart` hook in `~/.claude/settings.json` on
the first session inside that worktree, and by you where that hook
is not configured. The same hook puts the journal into context at
every later session and after every compaction, so its contents are
already in front of you. Append one line per decision at the moment
you make it, formatted as the choice, then an em dash, then what the
choice was responsive to. Fold the append into a Bash call you were
already making, so journaling costs a shell redirect rather than a
turn.

Log a decision when its answer to "what is this responsive to?" is
not one of: the user said so, the codebase does it this way here,
this is the industry convention. Copying a value from a prototype, a
neighbouring file, or an earlier branch does not count as the second
answer unless you checked that the reason it holds there also holds
here. Copying without that check produces a guess wearing a
citation, and it is the entry most often missing from these
journals.

Write entries as you go, never at the end. At wrap-up you hold a
finished diff in which a constant you copied and a constant you
deliberated read identically, so recall returns the decisions that
were hard, recent, or already discussed in conversation and drops
the ones that felt automatic. Those are most of them. A journal
whose entries were all written in its last minute did nothing.

## The gate at wrap-up

Read the journal, then decide whether this change has earned a
dossier. The test is not size: a two-thousand-line mechanical rename
has earned nothing, and a thirty-line change resting on a claim that
one deploy caused a step change in load has earned one. The test is
whether any claim about the world reached the artifact.

Three or more such claims, or any one of them encoded somewhere
costly to reverse later — a stored format, a schema, a cache key, an
interface boundary — means build the dossier. Fewer than that, say
so plainly, delete the journal, and stop. Do not produce a document
whose decision section is empty, because an empty one teaches the
reviewer to skim the next.

When no journal exists because the work is already done, reconstruct
from the diff, the commit messages, the pull request discussion, and
whatever survives in session. Stamp every reconstructed section as
reconstructed. The stamp does specific work: a reconstructed
decision list is missing the decisions that felt automatic, so the
stamp tells the reviewer to distrust its completeness rather than
its contents.

## Assembling the document

Copy `template.md` and fill it. Its section order lets the reviewer
stop early, and section 3 is the part no other artifact can supply.

Keep the marked boundary after section 3. Ordering alone makes the
depth below optional, and nothing tells the reviewer where their
obligation ends, so they read on or feel the document is long. The
divider says it outright. Sections 1 to 3 are the review; the rest
is the record.

Omit a section with nothing in it rather than writing "none" into
it. A template field answered with a blank costs the reader a
heading, a lookup and a shrug, and it teaches them that the next
heading may also be empty, which is the habit that makes them skim
the section that mattered. Sections 7 and 8 are the ones that
routinely have nothing to say.

Section 3 lists what driving the code will not reveal. Order it by
how invisible each decision is to someone exercising the feature, so
guards on paths that never fire, cases deliberately left unhandled,
retry counts, timeouts, and checks that only matter under attack
come first. A reviewer will open the thing and drive the happy path,
but they will not necessarily reach the empty state, the 403, or
page two. Your own sense of what is visible is biased toward
"visible", because you just wrote it and it is salient, so let that
bias order the list and never let it drop an item.

Give a decision in section 3 its default whenever a reader could not
predict it. The list arrives after the reviewer has already concluded
the work is finished, and a guess becomes permanent exactly when an
open question quietly persists. Where the decision already states
what the code does, the default repeats it, and six of those in a row
read as boilerplate and get skipped along with the two that carried
something.

Tag every claim in sections 4 through 6 with its source: measured
(name the method), asserted by the author, inherited from the
codebase, or guessed. An untagged claim is the failure this document
exists to prevent. The tags also separate a verified fact from a
draft, which an unfamiliar reader would otherwise take on trust.

Record refuted theories in section 5, separately from rejected
alternatives. A rejected alternative is a road not taken; a refuted
theory is a road someone will otherwise take again, because the
evidence that closed it lives in a session nobody else saw.

Put every run in section 6, and state each one once. Automated
coverage and a manual check are the same kind of fact — something was
run, and it establishes something — so splitting belief from
procedure across two sections makes you narrate each run twice, in
two vocabularies, and neither copy looks like a restatement of the
other.

Section 6 holds what was run to validate the change, never the
reading that motivated it. The tagging rule below puts sourced
evidence into sections 3, 4 and 5, so a section 6 that opens by
recounting which files were read states those facts a second time,
under the one heading that sounds entitled to them. Where the method
behind a claim needs recording, tag it in the section that makes the
claim rather than restating the claim where the method lives. The
first dossier written against the older template cited its
`python-base` symlink in both section 4 and section 6, and its
zipapp install in both section 5 and section 6.

Write section 6's "how this could be wrong" subsection about
measurement rather than reasoning. That is where this kind of work
fails: windows of different sizes compared as though they were
alike, an environment missing an index the production one has, a
tool's own artifact read as signal.

Never write the justification for a decision whose honest source is
"it had to be something". An unadorned arbitrary choice answers "why
this way?" with "it had to be some way", and the reviewer can see
that. The same choice with a rationale attached answers "because
condition X can occur" — a claim nobody made, in prose
indistinguishable from the sentence beside it that you read off the
code.

## Finalizing

Write it to
`~/work/work/claude-reference-docs/change-dossiers/<YYYY-MM-DD>-<slug>.md`.
That copy is the authoritative one, so leave nothing behind in the
repository and remove the worktree's `docs/` directory once it is
empty. Morgan browses that vault in Obsidian, which soft-wraps, so
write each paragraph as a single unbroken line, leave a blank line
after every heading, render the metadata block as a bulleted list,
and open with a bold AI-generated-draft warning under the title.
Copy the shape of the files already in `db-perf-reviews/` in the
same vault, which follow all of this.

The journal stays at `docs/change-dossiers/JOURNAL.md` inside the
worktree while the work happens, so add `docs/change-dossiers/` to
the repository's shared exclude file at
`$(git rev-parse --git-common-dir)/info/exclude` if it is not
already there — git ignores a per-worktree copy of that file and
honors only the shared one, so a single entry covers every worktree
of the repository and keeps the journal out of every commit.

Delete the journal once the dossier is written. It has no reader
after that, and one left behind reads as part of the deliverable.

Report the dossier's path in conversation, with the shortest route
to exercising the change and the section 3 list beneath it. Keep the
list out of the pull request body: that body is read by people who
were not present, to whom a decision list reads as noise or as
evidence the change is unreliable.
