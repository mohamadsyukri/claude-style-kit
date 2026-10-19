# claude-style-kit

My personal working and coding style for Claude Code, so every new project and every new machine
starts with it. Project-specific knowledge stays in each project's own `CLAUDE.md` and memory.

| Layer | Source in this repo | Installed as | Loaded |
|---|---|---|---|
| Core rules | `core/CLAUDE.md` | an `@import` line in `~/.claude/CLAUDE.md` | every session |
| Coding style | `skills/coding-style/` | symlink `~/.claude/skills/coding-style` | when coding |
| House rules | `hooks/superpowers-house-rules.md` | symlink in `~/.claude/hooks/`, injected at session start | every session |
| No AI attribution | `hooks/block-ai-attribution.sh` + `attribution` setting | symlink + `~/.claude/settings.json` | every commit/PR |
| Superpowers skills | cloned from `obra/superpowers` (pinned) | symlinks in `~/.claude/skills/` | when relevant |

Because everything is linked or imported, not copied, editing a file here changes Claude's behaviour
on the next session — no reinstall.

## Install on a new machine

    git clone https://github.com/mohamadsyukri/claude-style-kit.git ~/claude-style-kit
    ~/claude-style-kit/install.sh --dry-run   # shows what it would change
    ~/claude-style-kit/install.sh

Needs `git` and `python3`. The installer is safe to re-run: anything it replaces is moved to
`~/.claude/backups/style-kit-<timestamp>/` first, and anything already in place is left alone. It
keeps whatever else is in `~/.claude/CLAUDE.md` and `settings.json`.

## Update

- **Change a rule:** edit the file that owns the topic (the table in `skills/coding-style/SKILL.md`),
  commit, push.
- **Other machines:** `git -C ~/claude-style-kit pull`.
- **Where a rule goes:** `core/CLAUDE.md` only if it applies to every chat (keep it short — it costs
  context in every session); everything about code goes in the skill; anything that names one
  project's tables, scripts or branches goes in that project's `CLAUDE.md`, not here.

## New project

Copy the block in `skills/coding-style/project-claude-template.md` into the project's `CLAUDE.md`
and fill it in.

## Uninstall

Remove the `@…/core/CLAUDE.md` line from `~/.claude/CLAUDE.md`, the `attribution` key and the two
hook entries from `~/.claude/settings.json`, and the symlinks the installer listed. Backups are in
`~/.claude/backups/`.
