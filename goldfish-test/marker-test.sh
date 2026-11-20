#!/usr/bin/env bash
# Goldfish marker test: what does a "fresh" reviewer really see?
#
#   ./marker-test.sh setup [folder]            make the test folder (default: ~/goldfish-marker-test)
#                                              and copy this script into it
#   ./marker-test.sh check [folder] [save-to]  after the review: show which markers reached the
#                                              reports; with save-to, also save the table and reports there
#
# Each instruction file holds one made-up word. plan.md holds a fourth word (BANANA-03).
# BANANA-03 is the positive control: every reviewer reads the plan, so it must come back.
# If BANANA-03 does not come back, the probe failed and the test says nothing.
set -euo pipefail

mode="${1:-}"
dir="${2:-$HOME/goldfish-marker-test}"
save="${3:-}"
self="$(cd "$(dirname "$0")" && pwd)/$(basename "$0")"

setup() {
  if [ -e "$dir" ] && [ -n "$(ls -A "$dir" 2>/dev/null)" ]; then
    echo "STOP: $dir is not empty. Pick a new folder."; exit 1
  fi
  mkdir -p "$dir"
  cd "$dir"
  printf 'marker: PAPAYA-17\n' > CLAUDE.md
  printf 'marker: MANGO-42\n'  > AGENTS.md
  printf 'marker: KIWI-88\n'   > GEMINI.md
  cat > plan.md <<'PLAN'
# Plan: add a login page
marker: BANANA-03

## Open question for every reviewer
Before you use any tool, list every word that follows "marker:" in your
starting context, word for word. If you see none, write UNKNOWN.
Then say which of those words you found only by reading a file with a tool.
Then review the plan as usual.

## Steps
1. Add /login with an email and password form.
2. Store the session in a signed, HttpOnly cookie.
3. Lock the account for 15 minutes after 5 failed attempts.
PLAN
  cat > probe-subagent.txt <<'PROBE'
Use your subagent tool to start one general-purpose subagent. Give it only this
prompt and nothing else:

"Do not use any tools. List every word that follows 'marker:' in your starting
context, word for word. If you see none, write UNKNOWN."

Then print the subagent's answer word for word. Do not add your own answer.
After that, on a new line, list the marker words in YOUR starting context.
PROBE
  # Warn if a parent folder has its own instruction file: its words would leak in.
  p="$(dirname "$PWD")"
  while [ "$p" != "/" ]; do
    for f in CLAUDE.md AGENTS.md GEMINI.md; do
      [ -f "$p/$f" ] && echo "WARN: $p/$f exists. Move the test folder outside that tree."
    done
    p="$(dirname "$p")"
  done
  [ "$self" != "$PWD/marker-test.sh" ] && cp "$self" ./marker-test.sh && chmod +x ./marker-test.sh
  if command -v pbcopy >/dev/null 2>&1; then
    pbcopy < probe-subagent.txt && echo "OK  probe-subagent.txt is on the clipboard"
  fi
  echo "OK  test folder: $PWD"
  echo "OK  markers: CLAUDE.md=PAPAYA-17  AGENTS.md=MANGO-42  GEMINI.md=KIWI-88  plan.md=BANANA-03 (control)"
  echo "Next: cd $PWD"
}

check() {
  if [ -n "$save" ]; then
    mkdir -p "$save"
    report | tee "$save/check.txt"
    cp ./*report*.md "$save/" 2>/dev/null || true
    echo "OK  saved the table and the reports to $save"
  else
    report
  fi
}

report() {
  cd "$dir"
  shopt -s nullglob
  reports=( $(ls | grep -viE '^(CLAUDE|AGENTS|GEMINI|plan)\.md$|^probe-subagent\.txt$|\.sh$|^egm_context$' || true) )
  if [ ${#reports[@]} -eq 0 ]; then echo "STOP: no report files in $dir yet."; exit 1; fi
  printf '%-10s %-12s %s\n' MARKER SOURCE "REPORT FILES THAT NAME IT"
  for pair in "PAPAYA-17:CLAUDE.md" "MANGO-42:AGENTS.md" "KIWI-88:GEMINI.md" "BANANA-03:plan.md"; do
    m="${pair%%:*}"; s="${pair##*:}"
    hits="$(grep -l -- "$m" "${reports[@]}" 2>/dev/null | tr '\n' ' ' || true)"
    printf '%-10s %-12s %s\n' "$m" "$s" "${hits:-none}"
  done
  echo
  if grep -q -- BANANA-03 "${reports[@]}" 2>/dev/null; then
    echo "OK  control word found: the reports cover the plan. Now read the reports: did the reviewers answer the probe question, or decline it?"
  else
    echo "STOP: control BANANA-03 is not in any report. The probe failed: result is inconclusive."
  fi
}

case "$mode" in
  setup) setup ;;
  check) check ;;
  *) echo "Usage: $0 setup|check [folder]"; exit 1 ;;
esac
