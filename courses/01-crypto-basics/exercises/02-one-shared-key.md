🇬🇧 English · 🇳🇱 [Nederlands](02-one-shared-key.nl.md)

# 🛠 2 · One shared key (symmetric encryption)

⏱ 4 min · **Goal:** encrypt and decrypt with one shared key, and see why a
*tamper-evident* cipher (AEAD) matters.

## Step 1: lock and unlock

```bash
cd ~/lab/01
echo "The safe code is 4-8-15-16" > secret.txt
openssl enc -aes-256-cbc -pbkdf2 -in secret.txt -out secret.enc -pass pass:correct-horse
xxd secret.enc
```

The output starts with `Salted__` and then looks like noise. Now unlock it with
the right password, and then with a wrong one:

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -in secret.enc -pass pass:correct-horse
openssl enc -d -aes-256-cbc -pbkdf2 -in secret.enc -pass pass:wrong-horse
```

> 💡 `-pass pass:…` puts the password on the command line, where it ends up in
> your shell history. That's fine for a demo. In real life, leave it out and
> OpenSSL will ask for the password.

## Step 2: tamper with an encrypted payment

An attacker intercepts the encrypted message `Pay Bob 100 euro` and flips a
few bits. They **don't** know the key.

```bash
python3 "$COURSES/courses/01-crypto-basics/exercises/aead_demo.py"
```

```text
  AES-CBC (no seal)    😱 accepted, recipient reads: 'Pay Bob 900 euro. Regards, Alice'
  AES-256-GCM          🛡️  tampering detected, message refused
  ChaCha20-Poly1305    🛡️  tampering detected, message refused
```

## Step 3: speed

How fast is each lock? Each line takes about one second.

```bash
openssl speed -seconds 1 -bytes 16384 -evp aes-256-gcm 2>/dev/null | tail -1
openssl speed -seconds 1 -bytes 16384 -evp chacha20-poly1305 2>/dev/null | tail -1
openssl speed -seconds 1 -bytes 16384 -evp des-ede3-cbc 2>/dev/null | tail -1
```

The numbers are in thousands of bytes per second.

## 🤔 Questions

1. The wrong password gave `bad decrypt`. Is decryption with a wrong key
   *guaranteed* to fail loudly?
2. How could the attacker change `100` into `900` without the key?
3. TLS 1.3 only allows AEAD ciphers (GCM, ChaCha20-Poly1305). Why?
4. How much faster is AES-GCM than 3DES on this machine?
5. Both sides need the same key. How do you get it to the other side safely?
   (That's Part 2 of the talk.)

➡️ Next: [3 · Key pairs, PEM & DER](03-key-pairs.md)
