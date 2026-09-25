🇬🇧 English · 🇳🇱 [Nederlands](02-build-a-chain.nl.md)

# 🛠 2 · Build a chain of trust

⏱ 4 min · **Goal:** build the same shape as a real public chain, root →
intermediate → server, and see that **the CA decides** what goes into a certificate.

## Step 1: the root CA

The root signs itself. Its certificate says *"I'm a CA"* (`CA:TRUE`) and
*"I may sign certificates"* (`keyCertSign`).

```bash
mkdir -p ~/lab/02 && cd ~/lab/02
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out root.key
openssl req -x509 -new -key root.key -subj "/CN=Demo Root CA" -days 3650 \
    -addext "basicConstraints=critical,CA:TRUE" \
    -addext "keyUsage=critical,keyCertSign,cRLSign" \
    -out root.crt
```

## Step 2: the intermediate CA

In real life the root key lives offline in a safe; day-to-day signing is done by
an intermediate. `pathlen:0` means: *this CA may sign servers, but no further CAs*.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out intermediate.key
openssl req -new -key intermediate.key -subj "/CN=Demo Intermediate CA" -out intermediate.csr
printf 'basicConstraints=critical,CA:TRUE,pathlen:0\nkeyUsage=critical,keyCertSign,cRLSign\n' > intermediate.ext
openssl x509 -req -in intermediate.csr -CA root.crt -CAkey root.key -days 1825 \
    -extfile intermediate.ext -out intermediate.crt
```

## Step 3: the server certificate

The shop generates its own key and sends a CSR. The **CA** decides the
extensions: which names (SAN), and that it's for ServerAuth only.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out shop.key
openssl req -new -key shop.key -subj "/CN=shop.example" -out shop.csr
printf 'basicConstraints=CA:FALSE\nkeyUsage=critical,digitalSignature\nextendedKeyUsage=serverAuth\nsubjectAltName=DNS:shop.example,DNS:www.shop.example\n' > shop.ext
openssl x509 -req -in shop.csr -CA intermediate.crt -CAkey intermediate.key -days 90 \
    -extfile shop.ext -out shop.crt
openssl x509 -in shop.crt -noout -subject -issuer -dates -ext subjectAltName,extendedKeyUsage
```

## Step 4: verify the chain

Only the root is **trusted**. The intermediate is a helper the server hands out
(`-untrusted`: "use it to build the chain, but don't trust it by itself").

```bash
openssl verify -CAfile root.crt shop.crt
openssl verify -CAfile root.crt -untrusted intermediate.crt shop.crt
```

The first fails with `unable to get local issuer certificate`, the most common
TLS error there is. The second says `OK`.

## Step 5: the full chain file

This is what a web server should send: its own certificate **plus** the intermediate.

```bash
cat shop.crt intermediate.crt > fullchain.pem
grep -c "BEGIN CERTIFICATE" fullchain.pem
```

## 🤔 Questions

1. Why does the first `verify` fail, even though everything is signed correctly?
2. Which file must be guarded most carefully? And second most?
3. `shop.csr` only asked for a name. Who decided on `www.shop.example` and on
   ServerAuth? What does that tell you about "we'll just put it in the CSR"?
4. Why is the root not in `fullchain.pem`?

➡️ Next: [3 · Your own HTTPS server](03-your-own-https-server.md)
