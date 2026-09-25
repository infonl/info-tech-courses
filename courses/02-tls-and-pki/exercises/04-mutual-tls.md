🇬🇧 English · 🇳🇱 [Nederlands](04-mutual-tls.nl.md)

# 🛠 4 · Mutual TLS

⏱ 5 min · **Goal:** onboard partner *Acme* on mTLS with **our** private client
CA (model A), and see what the server does with good, missing and wrong client
certificates.

## Step 1: our client CA

A separate CA just for partner client certificates, so it can never be
confused with the server chain.

```bash
cd ~/lab/02
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out clientca.key
openssl req -x509 -new -key clientca.key -subj "/CN=Our Partner Client CA" -days 365 \
    -addext "basicConstraints=critical,CA:TRUE" -addext "keyUsage=critical,keyCertSign,cRLSign" \
    -out clientca.crt
```

## Step 2: Acme generates its key and sends a CSR

*This happens on Acme's side.* The private key never leaves Acme.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out acme.key
openssl req -new -key acme.key -subj "/O=Acme BV/CN=acme-api-client" -out acme.csr
```

## Step 3: we sign it, for ClientAuth only

*Back on our side.* In real life: first check that the CSR really comes from
Acme, for example by comparing its fingerprint over the phone.

```bash
openssl req -in acme.csr -noout -subject
printf 'basicConstraints=CA:FALSE\nkeyUsage=critical,digitalSignature\nextendedKeyUsage=clientAuth\n' > acme.ext
openssl x509 -req -in acme.csr -CA clientca.crt -CAkey clientca.key -days 90 -extfile acme.ext -out acme.crt
openssl verify -CAfile clientca.crt -purpose sslclient acme.crt
```

We send `acme.crt` back to Acme, and our server's CA (`root.crt`) if they don't have it yet.

## Step 4: a server that **requires** a client certificate

`-Verify 1` asks for a client certificate and requires one. `-verify_return_error`
makes the server **refuse** bad certificates instead of only logging them.

```bash
openssl s_server -accept 8443 -cert shop.crt -key shop.key -cert_chain intermediate.crt \
    -Verify 1 -verify_return_error -CAfile clientca.crt -www > server.log 2>&1 &
SERVER_PID=$!
sleep 1
```

## Step 5: three callers

Acme, with its certificate:

```bash
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt \
    --cert acme.crt --key acme.key https://shop.example:8443/ -o mtls.html
grep -A3 "Client certificate" mtls.html
```

Someone without a certificate:

```bash
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt https://shop.example:8443/ -o /dev/null
```

Mallory, with a certificate for the same name that she made herself:

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out mallory.key
openssl req -x509 -new -key mallory.key -subj "/O=Acme BV/CN=acme-api-client" -days 30 -out mallory.crt
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt \
    --cert mallory.crt --key mallory.key https://shop.example:8443/ -o /dev/null
```

## Step 6: clean up

```bash
kill $SERVER_PID
```

## 🤔 Questions

1. Match the two errors to the error decoder on the handout. Who has to fix each one?
2. Mallory's certificate has exactly the same name as Acme's. Why doesn't that help her?
3. Which files travelled between Acme and us? Which file never did?
4. Try step 4 **without** `-verify_return_error` and run Mallory again (then
   `kill $SERVER_PID`). What happens? What does that teach you about testing
   a partner's server configuration?

➡️ Bonus: [5 · Expiry and formats](05-bonus-expiry-and-formats.md)
