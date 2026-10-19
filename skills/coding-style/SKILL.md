---
name: coding-style
description: Syukri's personal coding style — file layout and naming, PHP/Laravel code and comments, frontend, migrations and seeders, live-data fixes, tests, the build-and-verify flow, and commit messages. Load before creating files, writing or changing code, writing a migration, seeder or test, or writing a commit message, in any project.
---

# Coding style

The always-on rules (English, plan first, no auto-commit, no destructive DB commands) are in
`~/.claude/CLAUDE.md`. This skill holds the detail. Read only the file for what you are about to do:

| About to… | Read |
|---|---|
| create files, folders or classes; choose names | [files-and-naming.md](files-and-naming.md) |
| write or change PHP/Laravel code, comments, docblocks | [php-laravel.md](php-laravel.md) |
| write Blade, JS, CSS or Livewire | [frontend.md](frontend.md) |
| write a migration or seeder, or touch data (local or live) | [database.md](database.md) |
| write or run tests; prove something works | [build-and-verify.md](build-and-verify.md) |
| stage, write a commit message, push, sync a branch | [git-and-commits.md](git-and-commits.md) |
| hit a docker / WSL / Xdebug / tooling oddity | [traps.md](traps.md) |
| start a new project | [project-claude-template.md](project-claude-template.md) |

## Which rule wins
1. My explicit instruction in the conversation.
2. The repo's own CLAUDE.md / AGENTS.md / config — it decides stack choices (Pest vs PHPUnit, Pint
   preset, `casts()` vs `$casts`, push flow).
3. This skill.
4. Generic skills (superpowers and others).

In an existing repo, **match the file you are editing and its siblings**. This skill sets defaults
for new code and new projects; it is not a licence to restyle old code.

## The ten that matter most
1. English identifiers and comments; the product's language only in user-facing strings.
2. Thin controllers → `final readonly` services; split a service before ~500 lines.
3. Comments say *why* at the line and cite evidence; numbers in comments are measured and dated.
4. Fail loud: no silent skips, no fabricated fallbacks, no dummy data.
5. Look rows up by name or code, never by a hard-coded auto-increment id.
6. Migrations are schema only, one change per file; data goes in idempotent seeders.
7. Verify by running: `php -l` → the covering test → drive the real page → query the data.
8. Format only the files you created or changed; no reformatting leaks into a commit.
9. One coherent issue per commit, tests included; subject `Area (Sub): what the user now sees`.
10. Commit body: source → cause with numbers → per-class changes → not done → verified.
