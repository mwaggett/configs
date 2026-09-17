# [Change name]

- Branch: [branch]
- Pull requests: [links]
- Ticket: [link]
- Written: [date]
- Status: assembled by Claude from [a decision journal kept during the work | reconstruction after the fact], not yet reviewed by the author

## 1. Outcome

[One to three sentences. What changed, and what it is for. A reader who stops here should know whether the change concerns them.]

## 2. Shortest route to exercising it

[The commands, requests, or clicks that drive the change. Name the environment and any data or flag state required. If driving it needs setup nobody would guess, say so here rather than leaving the reviewer to discover it.]

## 3. What exercising it will not reveal

[Every decision that encodes a claim about the world, ordered by how invisible it is to someone driving the feature: guards on paths that never fire first, then deliberately unhandled cases, retry counts, timeouts, log levels, error text describing a condition, then decisions visible only on the unhappy or rare path.]

[One entry per decision, each stating the choice, what it was responsive to, and — where a reader could not predict it — its default. Keep this to decisions that reached the artifact; every uncertainty entertained along the way is not this list.]

- **[Decision]** — chosen because [what it is responsive to]. Default: [what happens if nobody responds].

---

*Sections 1 to 3 are the review. Everything below is the record for whoever digs into this change later.*

---

## 4. Problem and inputs

[What prompted the change. The measurements, observations, tickets, and conversations that led here, with numbers where numbers exist.]

[Tag every claim: *measured* (name the method), *asserted by the author*, *inherited from the codebase*, or *guessed*.]

## 5. What we did, and what it displaced

[The approach, in design terms rather than mechanism — the diff carries mechanism.]

**Rejected alternatives.** [What else would have worked, and why this was chosen over it. Written for the maintainer who would otherwise re-propose it.]

**Refuted theories.** [Explanations that looked right and turned out to be wrong, with the evidence that closed them. Omit this subsection only if the work refuted nothing. A refutation nobody records gets re-investigated.]

## 6. Evidence

[Everything that was run, and what each run establishes. Automated coverage and manual checks belong together, because a test and a measurement are the same fact serving the same purpose: stating each once is what keeps this section from doubling. Give conditions where they matter — environment, host, data state.]

[What is deliberately not covered, and why. An unhandled case named here is intent; the same case unmentioned is indistinguishable from an oversight.]

**How this could be wrong.** [The measurement's own weaknesses: two windows compared against each other while covering spans of different length, so the longer one was averaged more coarsely; an environment whose indexes or version differ from production; a sample too small to separate the effect from host noise; a tool artifact read as data. Name what would have to be true for the conclusion to fail.]

## 7. Risk and rollback

- Blast radius: [what breaks if this is wrong, and for whom]
- Flag or gate: [name and state — drop this line if there is none]
- Revert safety: [whether reverting restores the prior behaviour on its own, and what a revert would leave behind — data written, migrations applied, caches keyed]
- Watch after deploy: [the specific metric, dashboard, or log line, and the value that would mean trouble]

## 8. Open questions and who decides

[What remains unsettled, phrased as the question rather than as a provisional answer, together with who owns it. A question written as an answer gets spent later as an established fact. Omit this section when nothing is outstanding — do not write "none".]

- [Question] — owner: [who decides]. Currently: [what the code does in the meantime].
