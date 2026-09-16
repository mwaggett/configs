## Workflow Preferences

- BE CONCISE. Prefer brief, high-level explanations over nitty-gritty details, unless I specifically ask you for a deep dive.
- Be precise and verify claims before stating them. If unsure, say so. Keep explanations brief, unless I ask for more. BE CONCISE and do not hallucinate!
- When debugging, try to understand the issue and how it came to be, rather than immediately trying to find solutions. I want to be able to prevent similar issues in the future, so I need to know how they happened. Keep explanations high-level, unless I ask for more detail. BE CONCISE.
- When asked a yes-or-no question, answer yes or no with only a **very** short explanation. I don't need the whole code chain you explored or an explanation of each individual bit of what I'm asking about. BE CONCISE.
- Don't infer instructions from statements of my own intent. When I say what *I'm* going to do ("I'm going to squash these", "I'll handle the deploy") — that is a statement about my own plan, not a request for you to do it. Do not treat it as delegation and perform the action yourself just because it's a natural next step or you have the tools available. Only act on things explicitly directed at you as a request or instruction. This matters most for hard-to-reverse or history-rewriting actions (git rebase/reset/squash/amend, force-push, deletions) — if it's ambiguous whether I'm narrating my own plan or asking you to act, ask which it is before touching anything, rather than assuming.
- When asked to provide a work plan, ask me for any info you don't have that will inform said plan **BEFORE** providing the plan. I don't want to scroll back through several iterations of a plan before getting to the final one.

### File editing

- Prefer direct file edits over sed-based approaches.
- When writing prose files (e.g. reports, docs, analysis, explanations, chat prose), write them as such - let them flow naturally with no wrapping or line length limits or anything like that, unless otherwise specified.
- When writing something I've specifically asked you to, don't put that long bar along the left side - I usually intend to copy+paste the content and that bar ruins the formatting.

#### Writing tests that reproduce a specific bug or vulnerability

- Derive the test scenario from the exact triggering condition in the source (or CVE/advisory) — quote or reference the actual conditional line — not from a paraphrased description of the bug. If the scenario can't be traced to a specific line, stop and re-check before writing the stub.
- Assert on the observable mechanism that defines the bug (e.g. a specific network call happening or not happening), not just a downstream side effect (e.g. some exception being raised). A downstream effect can occur for an unrelated reason and still satisfy the assertion, giving a false sense that the bug was reproduced.
- Before trusting a passing test, deliberately revert the fix and confirm the test fails for the *specific* expected reason — not just that it fails. A red run for the wrong reason means the test isn't testing what you think it is.
- Avoid stubbing when possible - tests should exercise actual work flows as much as they can.

### Git operations

- NEVER push to origin aka upstream repositories.
- Always ask before performing history-rewriting or destructive git operations — rebase, reset, squash, amend, force-push, deleting branches/tags — regardless of how the idea to do it came up (my own suggestion, something you said you were about to do yourself, or anything else). These are hard to reverse, or visible to others once pushed, so confirm first even when it seems like an obvious next step in the conversation. The cost of asking is much lower than the cost of guessing wrong.

#### Commit messages

- Concise yet detailed; explain *why*, not a line-by-line list of changes (the diff already shows that).
- Max line length: 80 characters. Be greedy - use as much of the line as you can. Wrapping should only occur when the next word would surpass the 80-character limit. This limit applies **only** to commit messages — nowhere else.
- Wrap context-specific nouns (hostnames, method/variable names, etc.) in backticks, like `this`.

### NEVER access remote servers

- Don't ever ssh into remote servers.
- Don't ever run ansible tasks or playbooks.
- Don't do anything ever on a remote server, read or write. If there's info you need, ask me and I will provide it.
