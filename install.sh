#!/usr/bin/env bash
# Install claude-style-kit into ~/.claude on this machine.
# Idempotent: anything already in place is left alone; anything replaced is moved to
# ~/.claude/backups/style-kit-<timestamp>/ first.
#
# Usage: ./install.sh [--dry-run]

set -euo pipefail

KIT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
SP_DIR="${HOME}/.claude-src/superpowers"
SP_REPO="${SUPERPOWERS_REPO:-https://github.com/obra/superpowers.git}"
SP_PIN="44c9b2d" # superpowers commit this kit was last checked against (2026-07-27)
BACKUP="${CLAUDE_DIR}/backups/style-kit-$(date +%Y%m%d-%H%M%S)"
DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

say() { printf '  %-8s %s\n' "$1" "$2"; }

# In a dry run, commands are skipped and the say() lines describe what would happen.
run() {
    [ "$DRY" = 1 ] || "$@"
}

# Move an existing file/dir/link aside so nothing is ever lost.
stash_aside() {
    run mkdir -p "$BACKUP"
    run mv "$1" "$BACKUP/"
    say "backup" "$1 -> $BACKUP/"
}

# link <target> <path>: make <path> a symlink to <target>.
link() {
    local target="$1" path="$2"
    if [ -L "$path" ] && [ "$(readlink "$path")" = "$target" ]; then
        say "ok" "$path"
        return
    fi
    if [ -e "$path" ] || [ -L "$path" ]; then
        stash_aside "$path"
    fi
    run ln -s "$target" "$path"
    say "linked" "$path -> $target"
}

command -v python3 >/dev/null || { echo "python3 is required" >&2; exit 1; }
command -v git >/dev/null || { echo "git is required" >&2; exit 1; }

echo "claude-style-kit: $KIT"
[ "$DRY" = 1 ] && echo "(dry run — nothing changes; the lines below are what a real run would do)"
run mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/hooks"
run chmod +x "$KIT/hooks/superpowers-session-start" "$KIT/hooks/block-ai-attribution.sh"

echo "1. coding-style skill"
link "$KIT/skills/coding-style" "$CLAUDE_DIR/skills/coding-style"

echo "2. hooks"
for f in superpowers-session-start superpowers-house-rules.md block-ai-attribution.sh; do
    link "$KIT/hooks/$f" "$CLAUDE_DIR/hooks/$f"
done

echo "3. superpowers skills"
if [ -d "$SP_DIR/.git" ]; then
    say "ok" "$SP_DIR (existing clone left as it is)"
else
    run mkdir -p "$(dirname "$SP_DIR")"
    run git clone --quiet "$SP_REPO" "$SP_DIR"
    run git -C "$SP_DIR" checkout --quiet "$SP_PIN"
    say "cloned" "$SP_REPO @ $SP_PIN"
fi
if [ -d "$SP_DIR/skills" ]; then
    for skill in "$SP_DIR"/skills/*/; do
        skill="${skill%/}"
        path="$CLAUDE_DIR/skills/$(basename "$skill")"
        if [ -L "$path" ] && [ "$(readlink "$path")" = "$skill" ]; then
            say "ok" "$path"
        elif [ -e "$path" ] || [ -L "$path" ]; then
            say "skip" "$path exists and isn't the superpowers link — left alone"
        else
            run ln -s "$skill" "$path"
            say "linked" "$path"
        fi
    done
fi

echo "4. core rules import in ~/.claude/CLAUDE.md, attribution off and hooks in ~/.claude/settings.json"
KIT="$KIT" CLAUDE_DIR="$CLAUDE_DIR" BACKUP="$BACKUP" DRY="$DRY" python3 - <<'PY'
import json, os, pathlib, shutil

kit = os.environ["KIT"]
claude = pathlib.Path(os.environ["CLAUDE_DIR"])
backup = pathlib.Path(os.environ["BACKUP"])
dry = os.environ["DRY"] == "1"


def say(tag, msg):
    print(f"  {tag:<8} {msg}")


def save(path, text):
    if dry:
        return
    if path.exists():
        backup.mkdir(parents=True, exist_ok=True)
        shutil.copy2(path, backup / path.name)
        say("backup", f"{path} -> {backup}/")
    path.write_text(text, encoding="utf-8")


# CLAUDE.md: prepend the import once; keep everything already there.
md = claude / "CLAUDE.md"
line = f"@{kit}/core/CLAUDE.md"
current = md.read_text(encoding="utf-8") if md.exists() else ""
if line in current.splitlines():
    say("ok", f"{md} imports the core rules")
else:
    header = f"# Personal style kit (added by {kit}/install.sh)\n{line}\n"
    save(md, header + ("\n" + current if current else ""))
    say("added", f"import line to {md}")

# settings.json: attribution off, SessionStart + PreToolUse hooks present. Other keys untouched.
sp = claude / "settings.json"
settings = json.loads(sp.read_text(encoding="utf-8")) if sp.exists() else {}
before = json.dumps(settings, sort_keys=True)

settings["attribution"] = {"commit": "", "pr": "", "sessionUrl": False}

hooks = settings.setdefault("hooks", {})


def ensure(event, marker, entry):
    entries = hooks.setdefault(event, [])
    for e in entries:
        for h in e.get("hooks", []):
            if marker in h.get("command", ""):
                return
    entries.append(entry)


ensure("SessionStart", "superpowers-session-start", {
    "matcher": "startup|clear|compact",
    "hooks": [{
        "type": "command",
        "command": "$HOME/.claude/hooks/superpowers-session-start",
        "shell": "bash",
        "async": False,
    }],
})
ensure("PreToolUse", "block-ai-attribution.sh", {
    "matcher": "Bash",
    "hooks": [{
        "type": "command",
        "command": "$HOME/.claude/hooks/block-ai-attribution.sh",
        "shell": "bash",
    }],
})

if json.dumps(settings, sort_keys=True) == before:
    say("ok", f"{sp} already has attribution off and both hooks")
else:
    save(sp, json.dumps(settings, indent=2) + "\n")
    say("updated", str(sp))
PY

echo "Done. Restart Claude Code (or run /clear) so the new rules and hooks load."
