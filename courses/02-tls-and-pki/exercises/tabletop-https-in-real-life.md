🇬🇧 English · 🇳🇱 [Nederlands](tabletop-https-in-real-life.nl.md)

# 🗣 Scenario cards: HTTPS in real life

⏱ 15 min · **In pairs.** No terminal needed; keep the [handout](../handout.md)
with the checklists and the error decoder next to you.

**How it works:** pick 3–4 cards. For each card, answer: **what's going on**,
**who has to act** (us, them, a supplier), and **what you would write back**
in two or three sentences. Be ready to present one card in the debrief.

---

## Card 1 · The padlock

A client writes: *"We checked the partner portal `portal-acme-support.com`
you sent us. It has a padlock, so it's safe, right?"* The partner's real domain is `acme.example`.

1. What does the padlock prove here? What doesn't it prove?
2. What would you check before saying "yes"?
3. How do you explain that to the client without jargon?

---

## Card 2 · "It works in my browser"

We launched `api.shop.example`. A partner's Java application reports
`PKIX path building failed`. Our developer says: *"It works fine in Chrome, so
it must be their problem."*

1. What's the most likely cause? (Hint: error decoder.)
2. Who fixes it, us or the partner?
3. Why does Chrome not show the problem?

---

## Card 3 · The new domain

Marketing moves the shop from `shop.example` to `www.shop.example` and adds
`shop.example.nl`. The next morning some users see a certificate warning.

1. What's wrong with the certificate?
2. What has to be requested, and who needs to be involved?
3. Could a wildcard `*.shop.example` have prevented this? For all three names?

---

## Card 4 · Onboarding Acme on mTLS

Acme will call our API with a client certificate. Their project manager asks:
*"What exactly do you need from us, and what do we get from you?"*

1. Choose a CA model (ours or theirs) and explain your choice.
2. List the steps in order, and who does each one. Use the handout's checklist.
3. Acme suggests *"just buy a client certificate from a public CA, that's
   easiest"*. What do you answer?
4. How do we make sure the CSR really came from Acme?

---

## Card 5 · The CDN and the private key

We put the shop behind a CDN / hosting provider that terminates HTTPS. Their
onboarding form asks us to *"upload your certificate and private key"*.

1. Is this a red flag, or reasonable? Why?
2. What alternative do most CDNs and platforms offer?
3. If we do upload the key: what changes about who we must trust, and what do we write down?

---

## Card 6 · 47 days

A customer's certificates are renewed by hand once a year by one system
administrator. Public certificates will soon be valid for at most 200 days,
then 100, then 47.

1. What happens to this way of working?
2. What do you recommend, in plain words?
3. Which three questions would you ask their hosting supplier?

---

## Card 7 · The pinned certificate (bonus)

A partner's mobile app **pins** our API's certificate. Our certificate renews
automatically every 60 days. After the last renewal, the app stopped working
for everyone.

1. What happened?
2. Short-term fix, and who does it?
3. How do you prevent a repeat, without giving up automated renewal?
