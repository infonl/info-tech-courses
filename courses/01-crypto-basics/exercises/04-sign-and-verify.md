🇬🇧 English · 🇳🇱 [Nederlands](04-sign-and-verify.nl.md)

# 🛠 4 · Sign & verify

⏱ 4 min · **Goal:** sign with a private key, verify with a public key, and find
out what a signature does *not* tell you.

You are Alice. `ec.key` is your private key; `ec.pub` is your public key,
which Bob already has.

## Step 1: sign a contract

```bash
cd ~/lab/01
echo "I, Alice, owe Bob 10 euro." > contract.txt
openssl dgst -sha256 -sign ec.key -out contract.sig contract.txt
xxd contract.sig | head -3
```

## Step 2: Bob verifies

```bash
openssl dgst -sha256 -verify ec.pub -signature contract.sig contract.txt
```

```text
Verified OK
```

## Step 3: Bob gets greedy

```bash
sed 's/10/1000/' contract.txt > forged.txt
openssl dgst -sha256 -verify ec.pub -signature contract.sig forged.txt
```

```text
Verification failure
```

## Step 4: Mallory signs her own forgery

Mallory makes her own key pair and signs the forged contract.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out mallory.key
openssl pkey -in mallory.key -pubout -out mallory.pub
openssl dgst -sha256 -sign mallory.key -out forged.sig forged.txt
```

Checked with **Alice's** public key:

```bash
openssl dgst -sha256 -verify ec.pub -signature forged.sig forged.txt
```

Checked with the public key Mallory helpfully sends along, "from Alice":

```bash
openssl dgst -sha256 -verify mallory.pub -signature forged.sig forged.txt
```

## Step 5: the modern way, Ed25519

```bash
openssl pkeyutl -sign -rawin -inkey ed25519.key -in contract.txt -out contract.ed25519.sig
openssl pkeyutl -verify -rawin -pubin -inkey ed25519.pub -in contract.txt -sigfile contract.ed25519.sig
wc -c contract.sig contract.ed25519.sig
```

## 🤔 Questions

1. Is `contract.txt` secret now that it's signed?
2. In step 4, the last check says `Verified OK`. What does that prove, and what doesn't it prove?
3. So what does Bob need to know about a public key before he trusts a signature?
   (That's Part 3 of the talk: **certificates**.)
4. If Alice's IT department had generated her key pair and kept a copy, could
   Alice still say "only I could have signed this"?

➡️ Bonus: [5 · Be your own notary (CA)](05-bonus-your-own-ca.md)
