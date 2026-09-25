#!/usr/bin/env bash
# Self-check for course NN. Only reads files in ~/lab/NN; run it as often as you like.
lab=~/lab/NN
passed=0 failed=0

ok()    { echo "  ✅ $1"; passed=$((passed + 1)); }
nok()   { echo "  ❌ $1"; echo "     hint: $2"; failed=$((failed + 1)); }
check() { local d=$1 h=$2; shift 2; if "$@" >/dev/null 2>&1; then ok "$d"; else nok "$d" "$h"; fi; }

cd "$lab" 2>/dev/null || { echo "No $lab yet. Start with exercise 1, step 1."; exit 1; }

echo "1 · First exercise"
check "hello.txt exists" "01-first-exercise, step 2" test -s hello.txt

echo
echo "$passed passed, $failed to go."
[ "$failed" -eq 0 ]
