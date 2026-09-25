🇬🇧 [English](cheatsheet.md) · 🇳🇱 Nederlands

# Spiekbriefje · 01 Crypto basics

Alle commando's werken met OpenSSL 3.x. `openssl <command> -help` laat alle
opties zien.

## Vingerafdrukken (hashes)

```shell
openssl dgst -sha256 file.txt
sha256sum file.txt
openssl x509 -in cert.crt -noout -fingerprint -sha256
```

## Symmetrische versleuteling

```shell
openssl enc -aes-256-cbc -pbkdf2 -in plain.txt -out secret.enc     # asks for a password
openssl enc -d -aes-256-cbc -pbkdf2 -in secret.enc
```

`openssl enc` kan geen AEAD-modes (GCM, Poly1305). Gebruik daarvoor een library,
zie `exercises/aead_demo.py`.

## Sleutelparen (key pairs)

```shell
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -out rsa.key
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out ec.key
openssl genpkey -algorithm ED25519 -out ed25519.key

openssl pkey -in ec.key -pubout -out ec.pub          # public key from private key
openssl pkey -in ec.key -noout -text                 # look inside
openssl pkey -in ec.key -aes256 -out ec-protected.key   # add a passphrase
```

## PEM ↔ DER

```shell
openssl pkey -pubin -in ec.pub -outform DER -out ec.pub.der    # public key
openssl x509 -in cert.crt -outform DER -out cert.der           # certificate
openssl x509 -inform DER -in cert.der -out cert.crt            # and back
openssl asn1parse -in ec.pub                                   # show the structure
```

## Ondertekenen & controleren

```shell
openssl dgst -sha256 -sign ec.key -out file.sig file.txt
openssl dgst -sha256 -verify ec.pub -signature file.sig file.txt

# Ed25519 signs the file directly
openssl pkeyutl -sign -rawin -inkey ed25519.key -in file.txt -out file.sig
openssl pkeyutl -verify -rawin -pubin -inkey ed25519.pub -in file.txt -sigfile file.sig
```

## Certificaten & CSR's

```shell
# CSR: public key + name, signed with your private key
openssl req -new -key ec.key -subj "/CN=shop.example" \
    -addext "subjectAltName=DNS:shop.example" -out shop.csr
openssl req -in shop.csr -noout -text

# Look at a certificate
openssl x509 -in shop.crt -noout -subject -issuer -dates -ext subjectAltName,extendedKeyUsage

# Does this certificate chain up to a CA I trust?
openssl verify -CAfile ca.crt shop.crt
openssl verify -CAfile ca.crt -purpose sslclient client.crt      # ClientAuth allowed?

# Does this certificate belong to this private key? (both lines must match)
openssl x509 -in shop.crt -noout -pubkey | openssl sha256
openssl pkey -in shop.key -pubout | openssl sha256
```

## Wat zit er in dit bestand?

```shell
head -1 unknown.pem                          # BEGIN CERTIFICATE / PRIVATE KEY / ...
openssl storeutl -noout -text unknown.file   # OpenSSL guesses the format
openssl pkcs12 -in bundle.p12 -info -nokeys  # what's inside a .p12/.pfx (asks for its password)
```
