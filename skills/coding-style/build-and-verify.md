# Build & verify

## Order of work
1. Check memory and notes for the module, files or issue.
2. Investigate read-only; reproduce the problem.
3. Plan: issue / cause / fix (+ alternatives) / how it will be checked, plus the footprint. Wait.
4. Before changing a symbol, find all its callers (the repo's code-graph tool if it has one, else
   grep). Treat an empty caller list as "unknown", not "unused".
5. Edit: read the file first; edit rather than rewrite; match the file's existing style.
6. Verify with the ladder below and quote the output.
7. Format only the files you touched.
8. Stage explicit paths, show the diff summary and the proposed commit message, then stop.

## Verification ladder — pick what matches the change, quote the output
1. `php -l` on every PHP file touched.
2. The covering test — write or extend one, and run just that file or filter.
3. Drive the real page for controller, route, view or JS changes: log in as a non-admin persona,
   navigate, submit, reload, read the values back; screenshot visual changes. Rendering catches
   missing lang keys and deleted route names that unit tests miss.
4. A query for data-shaped changes (counts before and after).

Then add a regression test for whatever the browser found, asserting the rendered markup rather than
component state. Ask before running the full suite.

Green isn't proof: check skip and assertion counts (zero-assertion passes and live-data skips both
look green). Compare failures with a baseline by error signature, not by totals. Re-run any suite
that ran across an infrastructure outage. Verify a deploy separately from verifying behaviour.

## Tests
- Pest or PHPUnit — whatever the repo uses. New projects: Pest, feature tests first.
- Name tests as behaviour in domain words: `it('moves the application from Draf to Lulus')`.
- Per-screen coverage order: access gate → cross-tenant 404 → happy save → each validation rejection
  → each state transition → child-record sync → delete rules → link rendering.
- A test creates its own preconditions — never asks live data for them — and pins a named fixture,
  never `Model::first()`. Tests that create data clean up after themselves (above a `MAX(id)`
  high-water mark, never by name).
- Test DB: new projects get a dedicated one (sqlite `:memory:` + `RefreshDatabase`). On a repo whose
  tests hit a real or shared DB, never `RefreshDatabase`: use `DatabaseTransactions` (listing every
  connection in `$connectionsToTransact`) or a throwaway sqlite schema per test, and say which in the
  test's docblock.
- A browser regression spec has a docblock naming the bug in the reporter's words, and a fixture
  that never changes data (make the save fail on purpose).
- Never delete tests without approval. Use factories and their states; cover happy, failure and odd
  paths.
- HTTP fakes: `Http::fakeSequence()` (a second `Http::fake()` merges and never matches);
  `Http::assertNothingSent()` on dry-run paths. Never name a test helper `run()` or `seed()`.
- Check access as a non-privileged account — admin bypasses hide missing grants.

## Formatting
- Run Pint (or the repo's formatter) only on files you created or changed, by explicit path on a
  legacy tree — never a bare run or `--dirty` there. Formatting is never verification.
- Match the style already in the file you edit, even where it disagrees with the formatter config.
- New projects get an `.editorconfig`: UTF-8, LF, 4 spaces (2 for YAML), final newline, trim
  trailing whitespace except in `.md`.

## Before saying "done"
- Put the evidence in the message: commands run, counts, pages driven — and what you did NOT verify.
- Report in the 5-part format; for reviews, "must change" vs "verified clean".
