# Frontend (Blade, JS, CSS, Livewire)

## Components and markup
- Reuse the repo's global components; never hand-roll a modal, table, button or form field.
  Reusable → promote it to a global component; one-off → a `_partials` include. No module-scoped
  component tier in between.
- Never a raw `<div class="modal fade">` or a JS `confirm()` — use the repo's standard confirm modal.
- No inline styles and no `@push` of a `<style>` block; page CSS lives in `resources/css/{module}/`
  and loads with `@vite`.
- Blade → JS data goes through descriptive `window.*` variables set with `@json`. Build complex
  payloads in an `@php` block first — `@json()` splits its argument on the first comma.
- Never write a literal `<x-…>` tag inside a Blade comment — Blade still compiles it.
- UI copy stays in the product's language; code and comments stay English. Read UI states from the
  mockup's own values (frame ids, hex fills) and cite them; never guess.
- Touch legacy views minimally: put new UI in a partial included by one line.
- Build form rows from the target schema, so users can't type a column that doesn't exist.

## Screen layout (my standard for admin screens)
- List actions (`+ Tambah`, Cetak, Carian) sit in the card's own header, right-aligned.
- Exactly one SIMPAN per tab, in the card footer. No KEMBALI inside cards. No autosave — edits are
  buffered until SIMPAN.

## Livewire (when the stack has it)
- Livewire only for tabs with real per-field state. Listings, pickers, uploads and modal-heavy
  screens are plain Blade + vanilla JS/jQuery — Livewire's DOM morph corrupts Bootstrap modals.
- Traps: wrap flatpickr + `wire:model` in `wire:ignore`; give shared form components an explicit
  `:value`; keep the save button inside the Livewire root; one root element; `wire:key` in loops.
- When choosing plain Blade over a component framework, leave a one-line why-not comment.

## jQuery plugins
- A global Select2 swallows native `change` events: bind with
  `$(container).on('change change.select2', selector, fn)`. Events fired with jQuery `.trigger()`
  never reach `addEventListener`, and a native-event test driver passes misleadingly.
- When stored data looks transformed and no server code explains it, look for a global client
  script (auto-uppercase and the like) before hunting in PHP.

## Listings
- Listings are Blade + server-side DataTables (yajra). Mark computed columns non-searchable (the
  global search 500s otherwise); on scoped lists, take the records total from the scoped query.

## When a change doesn't show
- Check for a stale `public/hot`, then ask me to run `npm run dev` / `npm run build`.
