# Creating files & naming

## Language
- English for every file, folder, class, method, variable, column and comment — even in a codebase
  whose UI is Malay. `evaluationList()`, not `senaraiPenilaian()`; `configuration/evaluation/`, not
  `configuration/penilaian/`. The product's language lives only in user-facing strings (labels,
  messages, lang files). A local variable may mirror a domain term when that reads clearer.
- Don't carry legacy Malay comments or legacy module prefixes on class names into new code.
- Descriptive names: `isRegisteredForDiscounts`, not `discount()`. One name means one concept —
  never positional names like `category_3_id`, never one column name reused for different meanings.

## Where files go
- Check sibling files first and follow them. When a repo has a newer reference module and a legacy
  majority, follow the reference module.
- No new top-level folders and no new dependencies without asking.
- Group by business process — the way users navigate (e.g. everything under "Konfigurasi" goes in
  `configuration/`).
- Default Laravel layout (new projects, or where the repo already works this way):
  - `app/Http/Controllers/{Main}/{Domain}/{Feature}Controller.php`
  - `app/Http/Requests/{Main}/{Domain}/{Store|Update}{Feature}Request.php`
  - `app/Services/{Main}/{Domain}/{Feature}Service.php` (sub-namespace once it grows)
  - `app/Models/{Main}/{Model}.php`
  - `resources/views/modules/{main}/{domain}/{feature}/{index,create,edit,show}.blade.php`
  - `resources/js/modules/…`, page CSS in `resources/css/{module}/` loaded with `@vite`
  - route names `{main}.{domain}.{feature}.{action}`; one route file per module
- PascalCase under `app/`; kebab-case files and folders under `resources/`. A `_`-prefixed Blade
  file is a non-routable include (`_form/`, `_partials/`).
- Page meaning: `index` = listing, `show` = view only (never hosts a form), `create`/`edit` share a
  `_form/` partial.
- Create files with the generator: `php artisan make:* --no-interaction` (`make:class`,
  `make:test`, `make:livewire`).
- Keep the repo's Laravel structure — an upgraded Laravel 10 layout stays that way unless asked.

## Size and layers
- Split a service into a sub-namespace before ~500 lines; keep methods short (aim for 20–40 lines).
- Controller methods stay ~10–15 lines: validate → call the service → respond.
- Layer by size: a small feature is Controller → Service → Model. Add a repository (interface in
  `app/Contracts/`, Eloquent class in `app/Repositories/`, bound in a service provider) only when
  data access is large or shared. Don't add a layer the repo doesn't have.

## Throwaway and personal files
- Scripts, importers and report generators needed only now → the session scratchpad, not the repo.
- Personal plan/spec notes → only when I ask; dated names (`YYYY-MM-DD-topic.md`); kept out of git
  with `.git/info/exclude` (never `.gitignore`, which is tracked). Don't assume an untracked folder
  is private — check whether the team tracks it.
- A prod data operation ships as numbered SQL files: `01_check.sql` (read-only),
  `02_apply.sql` (inside a transaction), `03_rollback.sql`.
