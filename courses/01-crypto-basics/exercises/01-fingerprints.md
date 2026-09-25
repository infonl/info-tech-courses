🇬🇧 English · 🇳🇱 [Nederlands](01-fingerprints.nl.md)

# 🛠 1 · Fingerprints (hashes)

⏱ 3 min · **Goal:** see that a hash is a fixed-size fingerprint, and that a tiny
change gives a completely different one.

## Step 1: make a lab folder

Everything you create today goes here, not in the repo.

```bash
mkdir -p ~/lab/01 && cd ~/lab/01
```

## Step 2: fingerprint an IOU

```bash
echo "I owe you 10 euro" > iou.txt
openssl dgst -sha256 iou.txt
sha256sum iou.txt
```

Two tools, the same fingerprint:

```text
SHA2-256(iou.txt)= f6815391bc6de475651235f636f768e65a60378f4fb44ec8af4617ffce8884cb
f6815391bc6de475651235f636f768e65a60378f4fb44ec8af4617ffce8884cb  iou.txt
```

## Step 3: forge it

```bash
echo "I owe you 1000 euro" > iou-forged.txt
openssl dgst -sha256 iou.txt iou-forged.txt
```

Two extra characters, and the fingerprint is completely different.

## Step 4: a big file

```bash
head -c 5000000 /dev/urandom > big.bin
openssl dgst -sha256 big.bin
```

## 🤔 Questions

1. How many hex characters is a SHA-256 fingerprint? How many bits is that?
2. Did the fingerprint get longer for the 5 MB file?
3. Could you get `I owe you 10 euro` back from its fingerprint?
4. Where have you seen fingerprints like this before?

➡️ Next: [2 · One shared key](02-one-shared-key.md)
