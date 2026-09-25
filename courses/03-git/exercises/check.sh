#!/usr/bin/env bash
# Self-check for course 03. Only reads the repositories in ~/lab/03; run it as often as you like.
lab=~/lab/03
passed=0 failed=0

ok()   { echo "  ✅ $1"; passed=$((passed + 1)); }
nok()  { echo "  ❌ $1"; echo "     hint: $2"; failed=$((failed + 1)); }
skip() { echo "  ⏭️  $1"; }
check() { local d=$1 h=$2; shift 2; if "$@" >/dev/null 2>&1; then ok "$d"; else nok "$d" "$h"; fi; }
g()    { git -C "$lab/shop" "$@"; }
has_commit() { g log "$1" --format=%s 2>/dev/null | grep -qF "$2"; }

[ -d "$lab/shop/.git" ] || { echo "No $lab/shop yet. Start with worksheet 1, step 1."; exit 1; }

echo "1 · Under the hood"
first_is_tagged() { [ "$(g rev-parse 'v1.0^{commit}')" = "$(g rev-list --max-parents=0 main)" ]; }
check "tag v1.0 sits on the very first commit" "01-under-the-hood, step 4" first_is_tagged
check "branch feature/prices exists" "01-under-the-hood, step 4" g rev-parse --verify -q feature/prices

echo "2 · Branches and merges"
has_merge() { [ -n "$(g rev-list --merges main)" ]; }
check "main has a merge commit (two parents)" "02-branches-and-merges, step 2" has_merge
resolved() { [ "$(g show main:prices.txt)" = "Apples: 1 euro" ]; }
check "the price conflict is resolved: 1 euro, no conflict markers" "02-branches-and-merges, step 4" resolved

echo "3 · Rebase, squash and cherry-pick"
check "feature/newsletter was rebased onto main (contains 'Sunday closing')" "03, step 2" \
    has_commit feature/newsletter "Sunday closing"
squashed() { has_commit main "Add newsletter sign-up" && ! has_commit main "fix typo"; }
check "main has one squashed newsletter commit, without 'wip' and 'fix typo'" "03, step 3" squashed
hotfix_only() { has_commit release/1.0 "Hotfix" && ! has_commit release/1.0 "Add price list"; }
check "release/1.0 has the hotfix, and nothing else from main" "03, step 4" hotfix_only

echo "4 · Oops: reflog and revert"
check "main still has the hotfix (rescued with the reflog)" "04, steps 1 and 2" has_commit main "Hotfix"
check "the bad price was reverted with a new commit" "04, step 3" has_commit main 'Revert "Update prices"'
secret_in_history() { [ -n "$(g log --all --format=%h -S hunter2)" ]; }
check "you found the password in the history" "04, step 4" secret_in_history

echo "5 · Bonus: collaboration"
if [ -d "$lab/origin.git" ]; then
    both() { git -C "$lab/origin.git" log main --format=%s | grep -q "Bob's idea" && git -C "$lab/origin.git" log main --format=%s | grep -q "Alice's idea"; }
    check "the shared repository has both Alice's and Bob's work again" "05, step 6" both
else
    skip "not started (that's fine, it's a bonus)"
fi

echo
echo "$passed passed, $failed to go."
[ "$failed" -eq 0 ]
