🇬🇧 English · 🇳🇱 [Nederlands](tabletop-who-sends-what.nl.md)

# 🗣 Scenario cards: who sends what?

⏱ 15–17 min · **In pairs.** No terminal needed; keep the
[handout](../handout.md) next to you.

**How it works:** read a card and answer its questions together. Write down or
sketch **who sends which file to whom**, with arrows between the parties. Cards
1–2 are warm-ups. Then pick any of 3–7. Be ready to present one card in the
debrief.

**The only rule you need:** *the private key stays home, the public key travels.*

---

## Card 1 · The signed contract (warm-up)

Alice signs a contract digitally and sends it to Bob.

1. Which key does Alice use to sign?
2. What does Bob need to check the signature, and where does he get it?
3. Which file must Alice never send along?
4. Can anyone else read the contract?

---

## Card 2 · The confidential file (warm-up)

Bob wants to send Alice a file that only she can open.

1. Whose key does Bob use to lock the file: his or Alice's? Private or public?
2. What does Alice have to send Bob beforehand?
3. Mallory intercepts that message and swaps in her own public key. What
   happens? How could Bob have noticed?

---

## Card 3 · Our web shop (ServerAuth, public CA)

We host `shop.example` for a customer. The certificate comes from a public CA
that every browser trusts.

1. Who generates the key pair? Where does the private key live?
2. What goes to the CA, and what comes back?
3. What do the shop's visitors need to do or install to trust it?
4. A visitor reports "certificate not trusted", but only on some older phones.
   What's a likely cause on *our* side?

---

## Card 4 · The internal API (ServerAuth, private CA)

We run `api.internal.example` for a partner. Its certificate comes from **our
own private CA**. The partner's developer mails: *"Your certificate is not
trusted. Can you send us your certificate and key so we can add them?"*

1. What does the partner actually need from us?
2. Is that safe to send? By e-mail?
3. What do you reply about the "and key" part?
4. The partner suggests turning off certificate checking "just for now".
   What's the risk?

---

## Card 5 · Acme calls our API (ClientAuth / mutual TLS)

Acme BV will call our API. We want to be sure that **only Acme** can call it,
so we require a client certificate (mTLS). Public CAs no longer issue ClientAuth
certificates.

1. Who generates Acme's key pair?
2. Option A: *our* private CA issues Acme's certificate. Draw the arrows.
   Which files travel, in which direction?
3. Option B: Acme has *its own* CA. Which file(s) do we need from Acme?
4. What must our server be configured with, in either option?
5. Our project manager offers: *"It's easier if we generate the key and
   certificate for Acme and mail them over."* What's wrong with that, besides
   the e-mail?

---

## Card 6 · The helpful e-mail

A supplier installing a monitoring tool on *their* systems writes:

> *"To connect to your environment, please send us the `.pfx` file of your
> production certificate and its password. We'll keep it safe."*

1. What's inside a `.pfx`?
2. What could the supplier do with it?
3. What do they probably actually need? What could you offer instead?
4. Is there a situation where handing over a `.pfx` *is* OK?

---

## Card 7 · Expiry Friday (bonus)

On Monday, Acme's client certificate turns out to expire on Friday. Acme sends
us a new certificate from the same CA.

1. Who has to act: Acme, us, or both?
2. What do we need to change on our side if we trust Acme's **CA**?
3. And if we had pinned Acme's old **certificate fingerprint**?
4. How do we avoid this Friday panic next time?
