🇬🇧 English · 🇳🇱 [Nederlands](05-bonus-your-own-ca.nl.md)

# 🛠 5 · Bonus: be your own notary (CA)

⏱ 5 min · **Goal:** follow a certificate from CSR to signed certificate, and see
who needs which file.

There are two roles. The **shop** (`shop.example`) owns `ec.key`. The
**notary** is a tiny private CA.

## Step 1: the notary sets up shop

The CA gets its own key pair and a certificate that says "I am the notary",
signed by itself. That makes it a **root** certificate.

```bash
cd ~/lab/01
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out ca.key
openssl req -x509 -new -key ca.key -subj "/CN=Demo Notary CA" -days 30 -out ca.crt
```

## Step 2: the shop fills in the application form (CSR)

The shop uses **its own** private key. It asks for a ServerAuth certificate.

```bash
openssl req -new -key ec.key -subj "/CN=shop.example" \
    -addext "subjectAltName=DNS:shop.example" \
    -addext "extendedKeyUsage=serverAuth" \
    -out shop.csr
openssl req -in shop.csr -noout -text | head -15
grep -c "PRIVATE KEY" shop.csr
```

The count is `0`: the CSR contains no private key, so it's safe to e-mail to the CA.

## Step 3: the notary checks and stamps

```bash
openssl x509 -req -in shop.csr -CA ca.crt -CAkey ca.key -days 7 \
    -copy_extensions copy -out shop.crt
openssl x509 -in shop.crt -noout -subject -issuer -dates -ext subjectAltName,extendedKeyUsage
openssl x509 -in shop.crt -noout -fingerprint -sha256
```

## Step 4: a visitor checks the passport

A visitor who trusts the notary (has `ca.crt`):

```bash
openssl verify -CAfile ca.crt shop.crt
```

A visitor who has never heard of this notary:

```bash
openssl verify shop.crt
```

Someone trying to use it as a **client** certificate (ClientAuth):

```bash
openssl verify -CAfile ca.crt -purpose sslclient shop.crt
```

## Step 5: does the certificate belong to the key?

```bash
openssl x509 -in shop.crt -noout -pubkey | openssl sha256
openssl pkey -in ec.key -pubout | openssl sha256
```

Same fingerprint, same key pair.

## 🤔 Questions

1. Which files did the shop send to the notary, and which did it get back?
2. Which file does a visitor need to trust `shop.crt`? Is it safe to hand out?
3. Which file must the notary guard best of all? What could someone do with it?
4. Why does the `-purpose sslclient` check fail? What would a partner need to
   use mutual TLS with your server?
5. Browsers wouldn't trust `shop.crt` either. Why not, and what would it take?

🎉 Done! Run the self-check:

```shell
bash "$COURSES/courses/01-crypto-basics/exercises/check.sh"
```
