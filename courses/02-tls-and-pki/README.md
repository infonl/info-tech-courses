🇬🇧 English · 🇳🇱 [Nederlands](README.nl.md)

# 02 · TLS & PKI in practice: HTTPS and beyond

| | |
|---|---|
| **Duration** | 45–50 min |
| **Audience** | Everyone who runs, buys, connects to or explains HTTPS sites and APIs, including partner connections with client certificates |
| **Tracks** | 🗣 **Explainers**: no terminal, scenario cards · 🛠 **Builders**: your own HTTPS server and mTLS in the sandbox |
| **Prerequisites** | [01 · Crypto basics](../01-crypto-basics/README.md), or be comfortable with "private key stays home, public key travels" and "a certificate is a signed public key". Builders: the sandbox ready, see [Joining a course](../../joining.md). |
| **Follow-up** | — |

## After this session you can…

**Everyone**

1. Explain what happens when someone opens `https://shop.example`, and what
   the padlock does and doesn't promise.
2. Name the checks a client does on a certificate: chain, name, dates, usage,
   and proof of the private key.
3. Recognise the common TLS error messages and say who has to fix them.
4. Explain why certificate lifetimes are shrinking to 47 days, and why that
   means renewal must be automated.

**🗣 Explainers, in addition**

5. Walk a partner through mTLS onboarding: which CA, which files travel which
   way, how names are checked, and who renews.

**🛠 Builders, in addition**

5. Build a root → intermediate → server chain, run an HTTPS server, break it in
   the three classic ways, add mutual TLS, and read expiry dates.

## Agenda

| Time | Part | Slides |
|------|------|--------|
| 0–3 | Hook: *"It has a padlock, so it's safe, right?"* | 1–4 |
| 3–11 | **Part 1 · HTTPS, step by step**: DNS, the TLS 1.3 handshake, what the browser checks, what the padlock means | 5–11 |
| 11–17 | **Part 2 · Chains in the wild**: trust stores, the missing intermediate, names, private CAs, TLS inspection | 12–17 |
| 17–22 | **Part 3 · Mutual TLS**: the handshake, onboarding a partner, server config | 18–22 |
| 22–27 | **Part 4 · Life cycle**: 47-day certificates, automation, monitoring, revocation, pinning, formats, recap | 23–31 |
| 27–43 | **Exercises**, pick your track | 32 |
| 43–50 | **Debrief**: the error decoder, and one scenario card | 33–34 |

## Materials

| | For | What |
|---|---|---|
| [slides.qmd](slides.qmd) | everyone | the deck, speaker notes included (`S` in the browser) |
| [handout.md](handout.md) | everyone, **print it** | go-live checklist, mTLS onboarding checklist, error decoder |
| [cheatsheet.md](cheatsheet.md) | 🛠 | `openssl` and `curl` commands for HTTPS and mTLS |
| [exercises/tabletop-https-in-real-life.md](exercises/tabletop-https-in-real-life.md) | 🗣 | scenario cards, one set per pair |
| [exercises/01-https-in-the-wild.md](exercises/01-https-in-the-wild.md) … [05-bonus-expiry-and-formats.md](exercises/05-bonus-expiry-and-formats.md) | 🛠 | terminal worksheets; `check.sh` checks your work |
| [solutions/](solutions/tabletop-answers.md) | facilitator | answers and discussion notes ([tabletop](solutions/tabletop-answers.md), [builders](solutions/builders.md)) |

## Exercises

**🗣 Explainers** work in pairs on the
[scenario cards](exercises/tabletop-https-in-real-life.md). Aim for 3–4 of the 7 cards.

**🛠 Builders** work through the worksheets. 2–4 are the core (about 15 min).
1 needs internet and can be skipped; 5 is a bonus.

| # | Worksheet | Time |
|---|-----------|------|
| 1 | [HTTPS in the wild](exercises/01-https-in-the-wild.md) | 3 min |
| 2 | [Build a chain of trust](exercises/02-build-a-chain.md) | 4 min |
| 3 | [Your own HTTPS server, and three ways to break it](exercises/03-your-own-https-server.md) | 6 min |
| 4 | [Mutual TLS](exercises/04-mutual-tls.md) | 5 min |
| 5 | [Bonus: expiry and formats](exercises/05-bonus-expiry-and-formats.md) | 4 min |

Check your progress at any time:

```shell
bash "$COURSES/courses/02-tls-and-pki/exercises/check.sh"
```

## Facilitator notes

- **A week before:** send the invite with a link to [Joining a course](../../joining.md)
  (NL: [Meedoen aan een cursus](../../joining.nl.md)).
- **Before:** run `make test`, print the handout and one set of scenario cards
  per explainer pair. Check whether the room has internet for worksheet 1 and
  for a live `curl -v https://…` on the big screen.
- **Live demo that works well:** at the end of Part 1, run
  `curl -v https://www.example.com -o /dev/null` on the big screen and point
  out the handshake lines, the certificate subject and issuer, and the expiry date.
- **Part 2 is where the support tickets are.** If you're short on time, shorten
  Part 4 rather than Part 2.
- **Debrief:** go through the error decoder on the handout. For each error, ask
  "who has to fix this, us or them?". Then have an explainer pair present
  card 4 (mTLS onboarding).
- Answers and discussion notes are in [solutions/](solutions/tabletop-answers.md).
