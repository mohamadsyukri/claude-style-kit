# House rules — these OUTRANK every superpowers skill

Superpowers is a methodology library, not a mandate. It advises; the rules below decide.

**Precedence, highest first:**

1. The user's explicit instruction in this conversation.
2. The project's `CLAUDE.md` (and `AGENTS.md`) in the repo being worked on.
3. The user's personal style kit (`~/claude-style-kit`: the core rules in `~/.claude/CLAUDE.md` and the `coding-style` skill) and auto-memory (`MEMORY.md` and the files it indexes).
4. Superpowers skills.

Where a superpowers skill conflicts with 1–3, follow 1–3 and say in one line which skill you set aside and why. Never cite a superpowers skill as a reason to override a project rule.

**Specific carve-outs:**

- **Git.** Use the project's own git workflow from its `CLAUDE.md` — branch, commit-message, and push conventions included. Do not substitute the workflow in `finishing-a-development-branch`, and never commit, push, open a PR, or merge on your own initiative unless that project's rules explicitly authorise it.
- **Worktrees.** Do not create git worktrees unless asked. `using-git-worktrees` is opt-in here.
- **Subagents.** Allowed without asking in every project whenever they make the work faster, with the guardrails in `~/.claude/CLAUDE.md` written into each agent's prompt. Multi-agent Workflows still need the user to say "use a workflow" or "ultracode".
- **Plan and spec files.** Write plan/spec/research markdown only when the user asks for it. Do not create documentation files as a side effect of a coding task.
- **Destructive database commands** stay forbidden regardless of what any workflow suggests.
- **Language.** Write everything — explanations, comments, notes, commit messages — in English.

**What to actually use superpowers for:** `systematic-debugging` when chasing a real bug, `brainstorming` when the design is genuinely open, `test-driven-development` when writing new logic, `verification-before-completion` before declaring work done. Reach for a skill when it fits the task, not as ceremony on every turn.
