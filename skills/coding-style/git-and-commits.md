# Git & commits

## What you may do
- Read-only git freely: `status`, `diff`, `log`, `fetch` to compare. Stage explicit paths when the
  work is done. Everything else — commit, push, pull, merge, rebase, reset, stash drop, force — only
  when I ask in that message. Commit and push are separate approvals, and approval to push my branch
  doesn't cover merging into a release branch.
- If you committed without asking, offer `git reset --soft HEAD~1`.

## Before staging
- Use `git status --porcelain --untracked-files=all` (`--short` hides untracked files inside folders).
- Compare `git diff -w` with the plain diff: if `-w` is much smaller, reformatting leaked in — strip
  it. A formatting sweep is its own commit, proposed separately.
- Stage explicit paths only; never `git add .`, `-A` or `commit -a`. Leave other sessions' changes
  and my own unrelated edits alone. Never stage `package-lock.json`.
- Rename similarity R100 means byte-identical: the edit you think you made isn't there.
- Never check a commit with `git stash push --keep-index` while a file is partially staged — the pop
  corrupts it.

## Granularity
- One coherent issue or feature per commit — a change a reviewer can hold in their head — with its
  tests in the same commit. Never bundle two issues; never split one by layer unless I ask.
- If several issues were built together: stage one issue, commit, repeat. Split shared files by hunk,
  or ask.
- When the work is staged, show the diff summary and the proposed message, then wait.

## Message format
Subject: `<Area> (<Sub>): <what changed, lowercase, no full stop>`
- Area is the module or feature as the product names it; Sub is the screen or sub-area, as named on
  screen.
- The summary states the user-visible outcome, imperative or present tense: `let …`, `stop …`,
  `keep …`, `show …`. UI labels keep their screen casing (SIMPAN, KEMBALI). Use `cover …` for
  test-only commits.
- English prose; product-language words only as names. No `feat:` / `fix(x):` prefixes.

Body — always present, wrapped at ~76 characters, prose paragraphs rather than a changelog:
1. **Source** — the ticket, tracker row or feedback quoted verbatim, when there is one.
2. **Cause** — what was wrong and why, with concrete numbers.
3. **Changes** — `- ClassName: what changed`, one bullet per class (or a Server: / Frontend: split).
4. **Scope** — what is deliberately unchanged; `(user decision: …)` notes.
5. **Not done:** — follow-ups, exact deploy commands, sibling commits by short hash.
6. **Verified:** — test names and counts, red before / green after, pages driven.

No trailers — no `Co-Authored-By`, no "Generated with", nothing.

Example subjects:

    Orders (Checkout): stop charging the delivery fee twice on split orders
    Reports (Monthly Summary): KEMBALI goes back to the list that opened the report
    Billing (Invoices): count only the latest quarter, and offer Jana Semula
    Users (Profile): keep every digit when pasting a phone number

When in doubt, read my own recent commits (`git log --author=<me> -n 20`), not teammates'.

## Branches and syncing
- Work on my personal branch; never commit straight to dev, main or a release branch.
- Sync with the release branch by merge (`--no-rebase`); never rebase over teammates' pushes. Watch
  for `pull.rebase=true` + `rebase.autoStash=true`: autostash un-stages files and a rebase drops merge
  commits. Re-stage after a pull.
- Compare against `origin/<branch>`, not a stale local branch. After a pull, earlier "tests green"
  claims are stale — re-run.
- Before a risky history operation, make a backup branch: `backup/<branch>-pre-<action>-<YYYYMMDD>`.
- Never rewrite published history or restyle teammates' commits.
- Before a push, list what rides along (`git rev-list --left-right --count HEAD...origin/<base>`)
  and check every file is in scope. Run the full suite before merging into a release branch.
- If the repo has a push script or PR flow, its CLAUDE.md says how — use that.
