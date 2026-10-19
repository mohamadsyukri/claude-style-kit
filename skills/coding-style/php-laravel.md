# Writing PHP / Laravel code

## Shape of new PHP
- `declare(strict_types=1);` on new files. Don't insert it into legacy files you are only touching —
  that is an incidental change.
- `final class`. Services are `final readonly` with promoted `private readonly` constructor
  dependencies. Models `final` with typed relations.
- Explicit parameter and return types everywhere; typed properties; PHPDoc array shapes
  (`@return array{id: int, name: string}`) whenever a method takes or returns an array.
- Curly braces on every control structure, even one-liners. Early returns. Named constants instead
  of magic values; keep legacy integer codes verbatim as named constants whose docblock points at the
  legacy source.
- Enum keys in TitleCase (or whatever the repo's enums already do).

## Layers and patterns
- Controller: validate with a Form Request → call one service method → respond. No business logic.
- Service: all business logic, one concern each, returns documented arrays or DTOs.
- A multi-button form posts one `form_action` string, handled with `match()`.
- Read-only vs editable is a view-data flag, so one Blade serves create, edit and view.
- Per-category behaviour = strategy classes in a container-bound registry keyed by code, with the
  category list in one enum. Never `new` inside a switch; never the same list in three places.
- Approval workflows: one class per state transition.
- Behaviour that repeats per item belongs in config or data rows, not code — keep one deliberate
  escape hatch (a handler class) for shapes the data can't express.

## Comments — the signature habit
- A comment justifies a decision; it never restates the code. Cite the source: legacy file:line, the
  mockup frame or hex value, the ticket row, why-not-the-alternative, named debt.
- Put the *why* at the step it explains. Docblocks are 3–6 lines, answering what a reviewer would
  challenge. No prose essays on top; no stock docblocks that repeat the method name.
- Every number in a comment is measured and dated ("0 orphans across 59,476 rows, 2026-08-17"),
  never recalled. A stale number is a defect: re-count it or delete it when you edit nearby.
- Comments in English, even where the legacy code around them is commented in Malay.

## Data correctness
- Fail loud by default. An unknown column is an error, not a silent drop. Skipping with only a log
  warning must be a deliberate, commented choice.
- Never fabricate a fallback (`if ($x === null) { $x = 1; }`). If a column has no honest value, the
  design is wrong.
- Resolve lookups by name or code, never a hard-coded auto-increment id — ids differ per environment.
  Refuse ambiguity: zero or two-plus matches → return null and write nothing.
- Never `orWhere('name', 'like', '%x%')->first()` without a scope and an order.
- Wrap multi-write operations, especially delete-then-insert, in `DB::transaction`.
- In a sweep over many items, catch, log and continue per item so one bad row doesn't end the run.
- Truncate free text to the column width at write time (`mb_substr($v, 0, 255)`); store garbage
  source values (year 1000, blanks) as NULL; trim after `explode()`.
- Never silently rewrite approved or frozen data — record the difference for a human to act on.
- Analysis and diff commands are read-only by default; writes only behind `--apply`.
- Before "fixing" a bug, check whether something depends on it. When stored data is wrong and many
  call sites read it, fix the data, not the call sites.
- When replacing legacy code, fix its bugs rather than copy them, and compare old vs new on the same
  current data (run the legacy path inside a rolled-back transaction).

## Laravel specifics
- Eloquent relations with return types; `Model::query()` over `DB::` in app code; eager-load against
  N+1; paginate with a fixed page size, never `paginate($query->count())`.
- `env()` only inside config files; `config()` everywhere else.
- Casts: `casts()` method on Laravel 11+, `$casts` on 10 — follow the neighbouring models. Date-only
  columns use `date:Y-m-d`, never a bare `date` cast (it serialises as UTC and shows the day before
  east of UTC).
- Links through named routes and `route()`. APIs: API Resources + versioning unless the repo differs.
- Code reachable from cron or a queue never assumes `auth()->user()`.
- Re-check ownership in the service (belongs to this parent AND this tenant); don't rely on route
  model binding where that check could be skipped.
- Merge rule arrays with `array_merge`, never `+` (the union silently keeps the left-hand keys).
- `firstOrCreate(['id' => …])` drops a non-fillable `id`; insert fixed-id rows with the query builder.
- Never put a dot in a column or field name.
- Lookup tables that admins edit: foreign keys `RESTRICT`, not `CASCADE`; give them a sort column.
- Redact secrets and personal data in logs, including URLs and response bodies. No live credentials
  as committed config literals.
