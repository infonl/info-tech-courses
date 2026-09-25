#!/usr/bin/env bash
# Translations must not drift: for every X.nl.md / X.nl.qmd, the ```bash blocks
# must be identical to those in the English X.md / X.qmd.
set -uo pipefail
cd "$(dirname "$0")/.."

bash_blocks() { awk '/^```bash[[:space:]]*$/ {on=1; next} /^```/ {on=0} on' "$1"; }

status=0
while IFS= read -r nl; do
    en=${nl/.nl./.}
    if [ ! -f "$en" ]; then
        echo "❌ $nl has no English source ($en)"; status=1; continue
    fi
    if ! diff -u --label "$en" --label "$nl" <(bash_blocks "$en") <(bash_blocks "$nl"); then
        echo "❌ commands differ between $en and $nl"; status=1
    fi
done < <(find . -path ./_site -prune -o \( -name '*.nl.md' -o -name '*.nl.qmd' \) -print | sed 's|^\./||' | sort)

[ $status -eq 0 ] && echo "✅ translations: commands match the English source"
exit $status
