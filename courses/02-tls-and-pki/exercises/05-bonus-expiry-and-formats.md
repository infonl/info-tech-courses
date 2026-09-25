🇬🇧 English · 🇳🇱 [Nederlands](05-bonus-expiry-and-formats.nl.md)

# 🛠 5 · Bonus: expiry and formats

⏱ 4 min · **Goal:** check expiry like a monitoring script does, and repackage
a certificate for Windows or Java without breaking the golden rule.

## Step 1: when does it expire?

```bash
cd ~/lab/02
openssl x509 -in shop.crt -noout -enddate
openssl x509 -in shop.crt -noout -checkend $((30*86400)) && echo "fine for 30 more days"
openssl x509 -in shop.crt -noout -checkend $((100*86400)) || echo "expires within 100 days: renew!"
```

`-checkend` gives exit code 0 or 1, which is what monitoring scripts use.

## Step 2: an expired certificate

We issue a certificate that was valid only in early 2025:

```bash
openssl x509 -req -in shop.csr -CA intermediate.crt -CAkey intermediate.key \
    -not_before 20250101000000Z -not_after 20250401000000Z -extfile shop.ext -out expired.crt
openssl verify -CAfile root.crt -untrusted intermediate.crt expired.crt
```

```text
error 10 at 0 depth lookup: certificate has expired
```

## Step 3: package it for Windows, IIS or Java

A `.p12` / `.pfx` holds the certificate, the chain **and the private key**,
protected by a password.

```bash
openssl pkcs12 -export -in shop.crt -inkey shop.key -certfile intermediate.crt \
    -out shop.p12 -passout pass:demo-only
openssl pkcs12 -in shop.p12 -info -nokeys -passin pass:demo-only 2>&1 | grep -E "subject|issuer"
```

## Step 4: a truststore holds no secrets

For a Java *client* that must trust our private root, you only need the root
certificate. Compare what's inside:

```bash
openssl pkcs12 -export -nokeys -jdktrust anyExtendedKeyUsage -in root.crt -out truststore.p12 -passout pass:demo-only
openssl pkcs12 -in truststore.p12 -info -noout -passin pass:demo-only 2>&1 | grep -iE "bag|key"
openssl pkcs12 -in shop.p12 -info -noout -passin pass:demo-only 2>&1 | grep -iE "bag|key"
```

## 🤔 Questions

1. Your monitoring runs `-checkend` against a file on a server. Why might
   users still see an expired certificate?
2. Which of `shop.p12` and `truststore.p12` may you send to a partner?
3. A supplier asks for "the .pfx of your certificate" to set up a connection
   to you. What do they probably need instead?

🎉 Done! Run the self-check:

```shell
bash "$COURSES/courses/02-tls-and-pki/exercises/check.sh"
```
