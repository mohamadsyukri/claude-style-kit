# Database: migrations, seeders, data fixes

## Limits (repeated from CLAUDE.md because they matter most here)
- You never run migrations, seeders, `migrate:fresh`/`refresh`, `db:wipe`, plain `db:seed` or any
  command that drops data. You write them; I run them. Every new migration needs my sign-off — never
  create one on your own initiative.
- Only the local DB is ever written. Remote and live DBs are read-only, and only when I ask.
- A migration is proven on a scratch copy (`migrate --path=<file>` with `-e DB_DATABASE=<copy>`),
  never on the working DB or a prod copy.

## Migrations
- Schema only. Data inserts and updates (reference rows, roles, menus, statuses, templates, config)
  go in seeders. The one exception is a backfill the schema change depends on (e.g. filling a new
  NOT NULL column). Test: would the DDL still apply without the row transform? Then it's a seeder.
- One table, or one kind of change, per file. Foreign keys go in a separate file from column changes.
  Name the file for what it does (`add_foreign_keys_to_x`). One change swept across many tables may
  share a file.
- Style: `return new class`; typed `up(): void` / `down(): void` and typed closures; no stock
  docblock; short `//` why-comments at the line; a 3–6 line docblock only when the reason isn't
  obvious.
- Foreign keys written longhand (`->foreign()->references()->on()->restrictOnDelete()`);
  `->after('col')`; `DB::statement` for MODIFY / RENAME INDEX / ENUM.
- Guards (`hasColumn`, `hasIndex`) only where a real re-run hazard exists — but always guard
  `dropForeign`: look the constraint up in `information_schema` and return early if it's absent.
- When modifying a column, restate every attribute it had, or they are dropped.
- `down()` really reverses. A destructive migration aborts with the live count if its "0 rows"
  premise no longer holds on the target.
- Migrations that touch rows match by name or value, never by id.
- Keep a running schema ledger while building, so the final migration is informed, not remembered.

## Seeders
- Idempotent: `updateOrCreate` / `firstOrCreate` / `upsert`, so a re-run is safe.
- Clear with `delete()`, never `truncate()` (its implicit commit breaks test rollback). Check the
  source is available BEFORE clearing the destination. Add a production refusal guard; use
  `$this->command?->` so seeders run from tests.
- A missing mapped column fails loudly — never silently aligned away. Never overwrite a stored value
  with a blank one.
- "It ran clean" proves nothing: compare non-null counts per column against the source and look for
  unmapped source columns.
- A family of near-identical seeders → one base class plus ~25-line concrete seeders with a
  `mapRow()` hook.
- No fabricated, dummy or placeholder data anywhere: migrations, seeders, runtime defaults, fixtures.
- Keep seeders in step with data-fix migrations, or the next re-seed undoes the fix.
- Never load seeder files in bulk (`class_exists`, `require`, reflection) — some run on include.

## Fixing data on a live environment
- You write it, I run it in my DB client. Dry-run the exact statements locally inside
  `START TRANSACTION … ROLLBACK` and check the affected rows. Hand me ONE self-contained block:
  SELECT before → change matched by current value (so a re-run does nothing) → SELECT after. Paste
  the full SQL in chat.
- Bulk changes: read-only check → backup plus an audit table of the exact ids → UPDATE in a
  transaction → check ROW_COUNT → rollback script driven by the audit table. Raw SQL skips the app's
  activity log, so the audit table is the trail.
- Changes to published figures or existing prod rows need the data owner's sign-off — propose them,
  don't apply them.
- Never change live data through the app server (kubectl exec, tinker).
- Answer data-shape questions (null rates, distributions) from a verified prod copy and schema
  questions from dev. Never import a prod dump over the working DB — use a side schema.
- When clearing bad values, key on a column that separates the populations, never on the bad value.
- MySQL 8: don't alias as `rows` or `groups` (reserved); force one collation on text match keys.
- When reference data looks wrong, check the audit log for who changed it before touching code.
