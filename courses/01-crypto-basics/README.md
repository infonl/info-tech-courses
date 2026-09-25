🇬🇧 English · 🇳🇱 [Nederlands](README.nl.md)

# 01 · Crypto basics: locks, keys, seals & passports

| | |
|---|---|
| **Duration** | 45–50 min |
| **Audience** | Everyone who deals with "certificates", "keys" or "SSL" at work, whether you configure it or need to explain it to a client |
| **Tracks** | 🗣 **Explainers**: no terminal, scenario cards · 🛠 **Builders**: terminal exercises in the sandbox |
| **Prerequisites** | Explainers: nothing, bring a pen. Builders: the sandbox open and `tools/ready.sh` all green (see [Joining a course](../../joining.md)). |
| **Follow-up** | [02 · TLS & PKI in practice](../02-tls-and-pki/README.md) |

## After this session you can…

**Everyone**

1. Name the three jobs crypto does: keep things **secret**, show **tampering**,
   prove **who** you're talking to.
2. Explain the golden rule, *the private key stays home, the public key
   travels*, and spot a request that breaks it.
3. Tell which files are safe to e-mail (certificate, CSR, CA certificate) and
   which never are (private key, `.p12`/`.pfx`).

**🗣 Explainers, in addition**

4. For a ServerAuth or ClientAuth (mTLS) set-up, say who generates the key
   pair, who signs the certificate, and who needs which CA certificate.

**🛠 Builders, in addition**

4. Generate RSA, EC and Ed25519 keys with `openssl`, convert PEM ↔ DER, sign and
   verify a file, and issue a certificate from your own mini-CA.

## Agenda

| Time | Part | Slides |
|------|------|--------|
| 0–3 | Hook: *"Can you just send us the certificate, the key and the password?"*, three jobs of crypto | 1–4 |
| 3–10 | **Part 1 · Secrets & fingerprints**: hash, symmetric key, AEAD | 5–8 |
| 10–18 | **Part 2 · Key pairs**: padlocks, wax seals, mixing paint, RSA vs EC | 9–15 |
| 18–26 | **Part 3 · Trust**: certificates, CAs, who needs what, safe files, red flags, answering the e-mail | 16–26 |
| 26–43 | **Exercises**, pick your track | 27 |
| 43–50 | **Debrief**: one scenario card, everyone together | 28 |

## Materials

| | For | What |
|---|---|---|
| [slides.qmd](slides.qmd) | everyone | the deck, speaker notes included (`S` in the browser) |
| [handout.md](handout.md) | everyone, **print it** | one page: golden rule, safe-file table, who-needs-what, red flags, questions to ask third parties |
| [cheatsheet.md](cheatsheet.md) | 🛠 | the `openssl` commands from the exercises |
| [exercises/tabletop-who-sends-what.md](exercises/tabletop-who-sends-what.md) | 🗣 | scenario cards, one set per pair |
| [exercises/01-fingerprints.md](exercises/01-fingerprints.md) … [05-bonus-your-own-ca.md](exercises/05-bonus-your-own-ca.md) | 🛠 | terminal worksheets; `check.sh` checks your work |
| [solutions/](solutions/tabletop-answers.md) | facilitator | answers and discussion notes ([tabletop](solutions/tabletop-answers.md), [builders](solutions/builders.md)) |

## Exercises

**🗣 Explainers** work in pairs on the
[scenario cards](exercises/tabletop-who-sends-what.md). Cards 1–2 are warm-ups;
3–7 are situations from real projects. Aim for 3–4 cards.

**🛠 Builders** work through the worksheets. 1–4 are core (about 15 min); 5 is a bonus.

| # | Worksheet | Time |
|---|-----------|------|
| 1 | [Fingerprints](exercises/01-fingerprints.md) | 3 min |
| 2 | [One shared key](exercises/02-one-shared-key.md) | 4 min |
| 3 | [Key pairs, PEM & DER](exercises/03-key-pairs.md) | 5 min |
| 4 | [Sign & verify](exercises/04-sign-and-verify.md) | 4 min |
| 5 | [Bonus: be your own notary (CA)](exercises/05-bonus-your-own-ca.md) | 5 min |

Check your progress at any time:

```shell
bash "$COURSES/courses/01-crypto-basics/exercises/check.sh"
```

## Facilitator notes

- **A week before:** send the invite with a link to [Joining a course](../../joining.md)
  (NL: [Meedoen aan een cursus](../../joining.nl.md)), so builders can run
  `tools/ready.sh` in advance.
- **Before:** open the sandbox yourself and run `make test` (or the `check.sh`
  line above after doing the worksheets). Print the handout for everyone and one
  set of scenario cards per explainer pair.
- **Ask the room** at the start who deals with certificates in which way. Let
  people choose their track; mixed pairs (one builder, one explainer on the
  scenario cards) work well too.
- **Timebox Part 3.** It's the most important part for explainers, so don't lose
  time on RSA maths in Part 2.
- **Debrief:** take scenario card 5 (Acme calls our API) or 6 (the helpful
  e-mail) and have one explainer pair present it. Ask the builders which files
  from their lab folder would travel where. Close by letting someone who
  hasn't spoken yet answer the opening e-mail (slide 2) in their own words.
- Common questions and answers are in [solutions/tabletop-answers.md](solutions/tabletop-answers.md).
