#!/usr/bin/env bash
# Smoke-test one course: run every ```bash block from its English worksheets
# (exercises/NN-*.md, in order) in a throwaway HOME, then run its check.sh.
#
#   tools/run-exercises.sh courses/01-crypto-basics
set -uo pipefail

course=$(cd "${1:?usage: $0 courses/NN-name}" && pwd)
COURSES=$(cd "$(dirname "$0")/.." && pwd)
export COURSES
HOME=$(mktemp -d)
export HOME
trap 'rm -rf "$HOME"' EXIT

script="$HOME/exercises.sh"
for f in "$course"/exercises/[0-9]*.md; do
    case "$f" in *.nl.md) continue ;; esac
    echo "echo '### $(basename "$f")'"
    awk '/^```bash[[:space:]]*$/ {on=1; next} /^```/ {on=0} on' "$f"
done > "$script"

echo "== $(basename "$course"): running $(grep -c '^echo .###' "$script") worksheets"
# No 'set -e': some steps fail on purpose (wrong password, forged signature).
bash "$script" > "$HOME/run.log" 2>&1

if bash "$course/exercises/check.sh"; then
    echo "== $(basename "$course"): OK"
else
    echo "== $(basename "$course"): FAILED — output of the worksheet commands:"
    cat "$HOME/run.log"
    exit 1
fi
