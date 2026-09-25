# Facilitator answers · Scenario cards (course 02)

## Card 1 · The padlock

1. It proves the connection is encrypted, and that the server controls
   `portal-acme-support.com` according to a trusted CA. It does **not** prove
   that the site belongs to Acme. Anyone can get a free certificate for any
   domain they own.
2. The **domain name**. Is it Acme's real domain (`acme.example`) or a
   look-alike? Ask Acme through a known channel. Optionally look at the
   certificate: an OV/EV certificate shows an organisation name, but browsers
   no longer highlight that.
3. *"The padlock means nobody can listen in on the line. It doesn't say who's
   on the other end. This address isn't Acme's usual domain, so let's check
   with Acme first."*

## Card 2 · "It works in my browser"

1. The server doesn't send the **intermediate** certificate (missing chain).
   Less likely: a private CA the partner doesn't have.
2. **Us.** Configure `fullchain.pem` (leaf + intermediates) on the server.
3. Chrome and other browsers fetch missing intermediates themselves (AIA
   fetching) or have them cached from other sites. Java, Python and curl don't.
   Test with `openssl s_client -showcerts` or an online checker, not a browser.

## Card 3 · The new domain

1. The certificate's **SAN list** doesn't include the new names.
2. A new certificate with all names in the SAN (`shop.example`,
   `www.shop.example`, `shop.example.nl`). Involve whoever runs the
   certificate automation or hosting, and DNS, because the CA must validate
   control of each domain. Lesson: add "certificate" to the checklist for any
   domain change.
3. `*.shop.example` covers `www.shop.example`, but **not** `shop.example`
   itself, and certainly not `shop.example.nl` (a different domain). A
   certificate can hold several names, including wildcards.

## Card 4 · Onboarding Acme on mTLS

1. **Our CA (model A)** gives us full control over issuing, lifetime and
   revocation; Acme only needs to send a CSR. **Their CA (model B)** is common
   with large partners who already run a PKI; then we must restrict trust to
   Acme's certificate name, because their CA also issues for others.
2. Follow the handout checklist: agree model and name → Acme generates the key
   → CSR (or CA chain) to us → verify origin → sign / configure trust →
   configure the server to trust the CA **and** check the name → test →
   agree renewal and incident contacts. Separate test and production.
3. Since 15 June 2026, public CAs no longer issue ClientAuth certificates
   (Chrome root program policy). So that option doesn't exist any more. And even
   before, a public CA would issue for anyone, so we'd still need a name check.
4. Compare the CSR's fingerprint
   (`openssl req -in acme.csr -outform DER | openssl sha256`) with Acme by
   phone, or receive it through an authenticated partner portal. Never trust a
   CSR just because the e-mail *says* it's from Acme.

## Card 5 · The CDN and the private key

1. **Reasonable, with care.** A CDN that terminates TLS acts as our server
   operator, so it needs a key to prove it's `shop.example`. The owner doesn't
   change in spirit (it's our delegated operator), but the key does leave our hands.
2. **Managed certificates**: the CDN generates the key itself and gets a
   certificate via ACME after we prove domain control (for example a DNS
   record). That's usually better: automatic renewal, and our key never travels.
3. The CDN can now pose as us, so it becomes part of our trust boundary
   (contract, security requirements). Write down where the key is, who can
   reach it, and how we rotate it if we leave. Upload through their portal,
   **never** by e-mail.

## Card 6 · 47 days

1. It breaks: at 47 days, you'd renew by hand about eight times a year per
   certificate, with every slip causing an outage. The single administrator is a
   single point of failure.
2. *"Let the computers renew the certificates. That's standard now (ACME,
   or the hosting platform's managed certificates). People only get involved
   when something goes wrong, and a monitor warns us weeks ahead."*
3. Is certificate renewal **automated** for all our certificates? Who gets the
   **alert** when renewal fails, and how far ahead? Do you keep an
   **inventory** of our certificates and their expiry dates?

## Card 7 · The pinned certificate

1. The app only accepts the **exact old certificate**. The automatic renewal
   produced a new certificate (and possibly a new key), so the pin no longer matches.
2. Short term: the **partner** ships an app update with the new pin, or a
   remote-config pin update if they have one. We can't fix it on the server,
   except by temporarily going back to the old key, if we still have it and it
   isn't expired.
3. Pin the **CA** (or intermediate), or pin the **public key** and keep
   reusing it across renewals. Always include a **backup pin**. Agree a
   rotation plan, and tell pinning partners ahead of key changes. Better still:
   reconsider whether pinning is needed at all.

## Common questions

- **"What's the difference between DV, OV and EV certificates?"** How much the
  CA checked: domain control only (DV), plus the organisation (OV), plus
  extended checks (EV). Browsers treat them the same now, so DV via ACME is
  the norm for websites.
- **"Is TLS 1.2 still OK?"** Yes, with modern ciphers. TLS 1.0 and 1.1 are
  retired (RFC 8996). TLS 1.3 is faster and simpler; enable both 1.2 and 1.3.
- **"What about quantum computers?"** Browsers and OpenSSL 3.5 already use a
  hybrid key agreement (X25519 + ML-KEM) in TLS 1.3. That protects against
  "record now, decrypt later". Post-quantum certificates are the next step.
