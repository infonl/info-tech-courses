🇬🇧 English · 🇳🇱 [Nederlands](03-key-pairs.nl.md)

# 🛠 3 · Key pairs, PEM & DER

⏱ 5 min · **Goal:** create key pairs, find the public half, and see that PEM
and DER are the same thing in two different wrappers.

## Step 1: three kinds of key pair

```bash
cd ~/lab/01
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -quiet -out rsa.key
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out ec.key
openssl genpkey -algorithm ED25519 -out ed25519.key
ls -l *.key
```

Note the permissions `-rw-------`: OpenSSL makes private keys readable by you only.

## Step 2: look inside a private key

```bash
head -3 ec.key
openssl pkey -in ec.key -noout -text
```

The file says `BEGIN PRIVATE KEY`. If you ever see that line in an e-mail, a
ticket or a Git repo, something went wrong.

## Step 3: take out the public half

```bash
for k in rsa ec ed25519; do openssl pkey -in $k.key -pubout -out $k.pub; done
cat ec.pub
```

This is the file you *can* share: `BEGIN PUBLIC KEY`.

## Step 4: PEM vs DER

PEM is text you can paste in an e-mail. DER is the same data in binary.

```bash
openssl pkey -pubin -in ec.pub -outform DER -out ec.pub.der
file ec.pub ec.pub.der
xxd ec.pub.der | head -3
```

PEM is just DER, base64-encoded, between a `BEGIN` and an `END` line. Check it:

```bash
sed '1d;$d' ec.pub | base64 -d | cmp - ec.pub.der && echo "identical bytes"
```

Look at the structure OpenSSL sees:

```bash
openssl asn1parse -in ec.pub
```

## Step 5: compare sizes

```bash
for k in rsa ec ed25519; do
  printf '%-8s public key: %4s bytes\n' $k "$(openssl pkey -pubin -in $k.pub -outform DER | wc -c)"
done
```

## In real life: protect the private key with a passphrase

This asks for a passphrase, so run it yourself if you like:

```shell
openssl pkey -in ec.key -aes256 -out ec-protected.key
head -1 ec-protected.key
```

## 🤔 Questions

1. Which of the files in `~/lab/01` could you safely e-mail to a partner?
2. The RSA and EC keys give about the same security. How big is the difference in size?
3. What does `file` say about `ec.pub` and `ec.pub.der`? Is it right? What
   does that tell you about trusting file names and tools that guess?
4. Can you make `ec.pub` from `ec.key`? And `ec.key` from `ec.pub`?

➡️ Next: [4 · Sign & verify](04-sign-and-verify.md)
