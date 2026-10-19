# Environment & tooling traps (each one has cost a session before)

## PHP and Laravel tooling
- Run artisan, tests, Pint and tinker inside the app's PHP container at the project's real path —
  host PHP lacks extensions. Tinker in a container may need `-e HOME=/tmp`.
- Run tests with `-e XDEBUG_MODE=off`: about 7× faster, and with Xdebug on, an `Http::fake`
  rejection through Guzzle segfaults about half the time (exit 139 is not your bug).
- `php -d memory_limit=` doesn't reach `artisan test` (it spawns a subprocess); set
  `<ini name="memory_limit">` in phpunit.xml.
- Never `route:cache` in development. A batch of Livewire tests failing while HTTP tests pass means a
  stale route cache → `route:clear`.
- Queued work silently stays pending when no worker is running.
- Calling a Laravel API needs `Accept: application/json`, or it answers with a 302 to the homepage.

## Docker and WSL
- After a WSL suspend or a compose recreate, a standalone DB container can lose its network →
  `docker network connect <network> <db-container>`, then restart. Never `docker rm` a container
  whose data lives on an anonymous volume.
- A single-file bind mount (e.g. php.ini) breaks when an editor writes-and-renames the file →
  recreate the container (`docker compose up -d --force-recreate <service>`).

## Reading evidence
- Absence of evidence isn't evidence: a collapsed git status, skipped tests (`s`), an empty caller
  set from a code graph — all have misled before. Confirm another way.
- Don't theorise from a generic error string; find the real log line first. Retry once before
  calling the network down. A network probe needs a known-open control to mean anything.
- Prod in local time and a dump in UTC show the same instant with different clock times.
- After changing DB rows that feed a cached UI, clear every related cache key.

## Boundaries
- If a permission or auto-mode block stops you, don't work around it — leave it to me.
- Only the main session makes live calls to external partner systems; subagents never do.
