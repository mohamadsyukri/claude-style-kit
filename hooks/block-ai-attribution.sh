#!/usr/bin/env bash
# PreToolUse(Bash) backstop for the "no AI attribution" rule. The attribution setting already stops
# Claude Code adding trailers; this catches one typed by hand into a commit or PR command.
# Reads the hook JSON on stdin; exit 2 blocks the call and shows stderr to Claude.

input="$(cat)"

if grep -qE 'git(\s+-C\s+\S+)?\s+commit\b|\b(gh|tea)\s+pr\s+(create|edit)\b' <<<"$input" \
  && grep -qiE 'co-authored-by|generated with \[?claude' <<<"$input"; then
  echo "Blocked by claude-style-kit: no Co-Authored-By or \"Generated with Claude Code\" lines in commits or PRs. Remove it and retry." >&2
  exit 2
fi

exit 0
