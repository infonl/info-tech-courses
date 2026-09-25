🇬🇧 English · 🇳🇱 [Nederlands](handout.nl.md)

# Keys & certificates: who needs what?

*Handout for course 01 · Crypto basics*

## The golden rule

> **The private key stays home. The public key travels.**
> Anyone who has your private key *is you*, as far as computers are concerned.

| Crypto job | Question | Done with |
|------------|----------|-----------|
| 🔒 Confidentiality | Can anyone else read this? | Encryption (AES-GCM, ChaCha20-Poly1305) |
| 🧾 Integrity | Did anyone change this? | Hashes, signatures, AEAD |
| 🪪 Authenticity | Who am I really talking to? | Signatures + certificates |

**Encrypt** with the *recipient's public key*. **Sign** with *your own private key*.
A **certificate** is a public key plus a name, signed by a **CA** (a notary).
It contains no secrets.

## Is this file safe to share?

| File | Contains | Share with another party? |
|------|----------|:-------------------------:|
| `.csr` | public key + name (certificate request) | 🟢 yes |
| `.crt`, `.cer` | certificate | 🟢 yes |
| `ca.crt`, `chain.pem`, `ca-bundle.crt` | CA certificate(s) | 🟢 yes |
| `.key` | private key | 🔴 **never** |
| `.p12`, `.pfx` | certificate **+ private key** | 🔴 **never** |
| `.jks` | Java keystore, often with private keys | 🔴 unless it only holds CA certificates (a *truststore*) |
| `.pem`, `.der` | could be anything | 👀 look inside |

**Open a `.pem` in a text editor.** `-----BEGIN CERTIFICATE-----` or
`-----BEGIN CERTIFICATE REQUEST-----` is fine to share.
`-----BEGIN PRIVATE KEY-----` (or `RSA`/`EC`/`ENCRYPTED PRIVATE KEY`) is **not**.

## ServerAuth: "clients check they're talking to the real server"

| Step | Who |
|------|-----|
| Generate the key pair, keep the private key | **Server owner** |
| Send a CSR to the CA; install the certificate **+ intermediate(s)** | **Server owner** |
| Trust the CA's **root** certificate | **Clients**. Automatic with a public CA; with a **private CA**, the server owner must **give them the root CA certificate** |

## ClientAuth / mutual TLS: "the server checks who is calling"

| Step | Who |
|------|-----|
| Generate the key pair, keep the private key | **The client** (the calling party), on its own systems |
| Agree which CA issues the client certificate | **Both**. Since June 2026 this is a **private CA**, because public CAs no longer issue ClientAuth certificates |
| CA model A: *our* CA. Client sends a **CSR**, we sign and return the **certificate** | Client → us → client |
| CA model B: *their* CA. Client sends its **CA certificate chain** | Client → us |
| Configure the issuing CA certificate(s) as trust anchor; optionally also check the certificate's name or fingerprint | **The server** (the checking party) |

## Questions to ask a third party

1. Who is authenticating whom: are we the **server**, the **client**, or both?
2. Which **CA** issues the certificates? Public, ours, or theirs?
3. What do you need from us? (Expected answer: a **CSR**, a **certificate** or a
   **CA certificate**. Never a private key.)
4. Which **name** (CN / SAN) will the certificate carry, so we can check it?
5. How long is it **valid**, who renews it, and how much notice do we get?
6. How do we tell each other if a key is **compromised** (revocation)?
7. Separate certificates for **test and production**?

## Red flags 🚩

- "Send us the private key / the .pfx and its password."
- "We'll generate your key pair and e-mail it to you."
- "Just turn off certificate verification for now."
- "It's self-signed, just click accept."
- "We use the same certificate and key for all our customers."

## Reply template

> We're happy to send our **certificate and the CA chain**. The private key
> stays with us, so nobody else can pose as us. If you need to authenticate us
> as a client, tell us which **CA** you accept and we'll send you a **CSR**.
