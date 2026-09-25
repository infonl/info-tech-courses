#!/usr/bin/env bash
# Self-check for course 02. Only reads files in ~/lab/02; run it as often as you like.
lab=~/lab/02
passed=0 failed=0

ok()   { echo "  ✅ $1"; passed=$((passed + 1)); }
nok()  { echo "  ❌ $1"; echo "     hint: $2"; failed=$((failed + 1)); }
skip() { echo "  ⏭️  $1"; }
check() { local d=$1 h=$2; shift 2; if "$@" >/dev/null 2>&1; then ok "$d"; else nok "$d" "$h"; fi; }
ext()  { openssl x509 -in "$1" -noout -ext "$2" 2>/dev/null; }

cd "$lab" 2>/dev/null || { echo "No $lab yet. Start with worksheet 1 or 2, step 1."; exit 1; }

echo "1 · HTTPS in the wild"
skip "a look-around, nothing to check"

echo "2 · Build a chain of trust"
root_is_ca() { ext root.crt basicConstraints | grep -q "CA:TRUE"; }
check "root.crt is a CA certificate" "02-build-a-chain, step 1" root_is_ca
check "intermediate.crt is signed by the root" "02-build-a-chain, step 2" \
    openssl verify -CAfile root.crt intermediate.crt
check "shop.crt chains up to the root via the intermediate" "02-build-a-chain, steps 3 and 4" \
    openssl verify -CAfile root.crt -untrusted intermediate.crt -purpose sslserver shop.crt
both_names() { ext shop.crt subjectAltName | grep -q "DNS:shop.example" && ext shop.crt subjectAltName | grep -q "DNS:www.shop.example"; }
check "shop.crt is valid for shop.example and www.shop.example" "02-build-a-chain, step 3 (shop.ext)" both_names
full_chain() { [ "$(grep -c 'BEGIN CERTIFICATE' fullchain.pem 2>/dev/null)" = 2 ]; }
check "fullchain.pem holds the server certificate plus the intermediate" "02-build-a-chain, step 5" full_chain

echo "3 · Your own HTTPS server"
check "you fetched a page over HTTPS (page.html)" "03-your-own-https-server, step 2" grep -q "s_server" page.html

echo "4 · Mutual TLS"
check "acme.crt is a ClientAuth certificate from our client CA" "04-mutual-tls, step 3" \
    openssl verify -CAfile clientca.crt -purpose sslclient acme.crt
acme_owns_key() { [ -f acme.key ] && [ "$(openssl x509 -in acme.crt -noout -pubkey)" = "$(openssl pkey -in acme.key -pubout)" ]; }
check "acme.crt belongs to Acme's own key" "04-mutual-tls, steps 2 and 3" acme_owns_key
check "the server saw Acme's client certificate (mtls.html)" "04-mutual-tls, step 5" grep -q "acme-api-client" mtls.html

echo "5 · Bonus: expiry and formats"
if [ -f expired.crt ] || [ -f shop.p12 ]; then
    is_expired() { ! openssl x509 -in expired.crt -noout -checkend 0; }
    check "expired.crt has expired" "05-bonus, step 2" is_expired
    check "shop.p12 opens with its password" "05-bonus, step 3" \
        openssl pkcs12 -in shop.p12 -nokeys -passin pass:demo-only -noout
    no_key() { ! openssl pkcs12 -in truststore.p12 -info -noout -passin pass:demo-only 2>&1 | grep -qi "shrouded keybag"; }
    check "truststore.p12 contains no private key" "05-bonus, step 4" no_key
else
    skip "not started (that's fine, it's a bonus)"
fi

echo
echo "$passed passed, $failed to go."
[ "$failed" -eq 0 ]
