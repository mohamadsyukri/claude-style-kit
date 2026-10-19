# Project layer template

Copy the block below into a new project's `CLAUDE.md` and fill it in. Keep it to what only this
project knows — personal style already comes from `~/claude-style-kit`.

```markdown
# <Project name>

## Stack
- Laravel <version>, PHP <version>, <Pest | PHPUnit>, <Livewire | plain Blade>, <MySQL | MariaDB>

## Running things
- PHP container: `docker exec -e XDEBUG_MODE=off -w /var/www/projects/<path> <php-container> php artisan …`
- Local URL: http://<name>.test — test login: <persona>
- Tests: `php artisan test --compact <file>` — test DB: <sqlite :memory: | db name>

## Git
- Work branch: <branch>. Base branch: <dev | main>. Push: <command, or "ask me">.
- Commit Area names: <the module names to use in commit subjects>

## Scope
- Never touch: <modules owned by others, generated files, vendored code>
```
