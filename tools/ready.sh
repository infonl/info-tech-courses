#!/usr/bin/env bash
# "Am I ready for the course?" Run it in the terminal you'll use during the session.
repo=$(cd "$(dirname "$0")/.." && pwd)
missing=0

ok()  { echo "  ✅ $1"; }
nok() { echo "  ❌ $1"; echo "     hint: $2"; missing=$((missing + 1)); }

echo "Checking your course environment…"

version=$(openssl version 2>/dev/null)
case "$version" in
    "OpenSSL 3."*) ok "$version" ;;
    LibreSSL*)     nok "$version: that's LibreSSL (macOS), not OpenSSL 3" "use the sandbox, or: brew install openssl@3" ;;
    "")            nok "openssl not found" "use the sandbox (see joining.md)" ;;
    *)             nok "$version is too old" "use the sandbox, which has OpenSSL 3.5" ;;
esac

if python3 -c "import cryptography" 2>/dev/null; then
    ok "Python with the cryptography library"
else
    nok "Python 'cryptography' library not found" "use the sandbox, or: sudo apt install python3-cryptography"
fi

for tool in xxd file; do
    if command -v "$tool" >/dev/null; then ok "$tool"; else nok "$tool not found" "use the sandbox, or: sudo apt install $tool"; fi
done

if [ -n "${COURSES:-}" ] && [ -d "$COURSES/courses" ]; then
    ok "COURSES points to the course files ($COURSES)"
else
    nok "COURSES is not set" "in the sandbox it's set for you; otherwise run: export COURSES=$repo"
fi

echo
if [ "$missing" -eq 0 ]; then
    echo "🎉 You're ready. See you at the course!"
else
    echo "$missing thing(s) to fix. No time? Join anyway: you can pair up with someone or follow along on the big screen."
    exit 1
fi
