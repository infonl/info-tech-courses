#!/usr/bin/env bash
# Self-check for course 01. Only reads files in ~/lab/01; run it as often as you like.
lab=~/lab/01
passed=0 failed=0

ok()   { echo "  ✅ $1"; passed=$((passed + 1)); }
nok()  { echo "  ❌ $1"; echo "     hint: $2"; failed=$((failed + 1)); }
skip() { echo "  ⏭️  $1"; }
# check "description" "hint" command...
check() { local d=$1 h=$2; shift 2; if "$@" >/dev/null 2>&1; then ok "$d"; else nok "$d" "$h"; fi; }
fp()   { openssl dgst -sha256 -r "$1" 2>/dev/null | cut -d' ' -f1; }
pub()  { openssl pkey -in "$1" -pubout 2>/dev/null; }

cd "$lab" 2>/dev/null || { echo "No $lab yet. Start with exercise 1, step 1."; exit 1; }

echo "1 · Fingerprints"
different_fps() { [ -f iou.txt ] && [ -f iou-forged.txt ] && [ "$(fp iou.txt)" != "$(fp iou-forged.txt)" ]; }
check "iou.txt and iou-forged.txt have different fingerprints" "01-fingerprints, steps 2 and 3" different_fps

echo "2 · One shared key"
decrypts() { [ -s secret.txt ] && [ -f secret.enc ] && [ "$(openssl enc -d -aes-256-cbc -pbkdf2 -in secret.enc -pass pass:correct-horse 2>/dev/null)" = "$(cat secret.txt)" ]; }
check "secret.enc decrypts back to secret.txt" "02-one-shared-key, step 1" decrypts

echo "3 · Key pairs, PEM & DER"
check "rsa.key is a 3072-bit RSA key" "03-key-pairs, step 1" \
    bash -c 'openssl pkey -in rsa.key -noout -text | grep -q "3072 bit"'
check "ec.key is a P-256 key" "03-key-pairs, step 1" \
    bash -c 'openssl pkey -in ec.key -noout -text | grep -q "prime256v1"'
check "ed25519.key is an Ed25519 key" "03-key-pairs, step 1" \
    bash -c 'openssl pkey -in ed25519.key -noout -text | grep -q "ED25519"'
matches_key() { [ -f ec.pub ] && [ "$(pub ec.key)" = "$(cat ec.pub)" ]; }
check "ec.pub is the public half of ec.key" "03-key-pairs, step 3" matches_key
same_der() { [ -f ec.pub.der ] && openssl pkey -pubin -in ec.pub -outform DER | cmp -s - ec.pub.der; }
check "ec.pub.der holds the same key as ec.pub" "03-key-pairs, step 4" same_der

echo "4 · Sign & verify"
check "contract.sig verifies with Alice's public key" "04-sign-and-verify, step 1" \
    openssl dgst -sha256 -verify ec.pub -signature contract.sig contract.txt
rejects_forgery() { [ -f forged.txt ] && ! openssl dgst -sha256 -verify ec.pub -signature contract.sig forged.txt; }
check "the forged contract does NOT verify" "04-sign-and-verify, step 3" rejects_forgery

echo "5 · Bonus: your own CA"
if [ -f shop.crt ]; then
    check "shop.crt is signed by your CA" "05-bonus-your-own-ca, step 3" \
        openssl verify -CAfile ca.crt shop.crt
    cert_matches_key() { [ "$(openssl x509 -in shop.crt -noout -pubkey)" = "$(pub ec.key)" ]; }
    check "shop.crt carries the public key of ec.key" "05-bonus-your-own-ca, step 2" cert_matches_key
else
    skip "not started (that's fine, it's a bonus)"
fi

echo
echo "$passed passed, $failed to go."
[ "$failed" -eq 0 ]
