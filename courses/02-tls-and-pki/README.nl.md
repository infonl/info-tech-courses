🇬🇧 [English](README.md) · 🇳🇱 Nederlands

# 02 · TLS & PKI in de praktijk: HTTPS en verder

| | |
|---|---|
| **Duur** | 45–50 min |
| **Doelgroep** | Iedereen die HTTPS-sites en API's beheert, inkoopt, erop aansluit of uitlegt, ook partnerkoppelingen met clientcertificaten |
| **Tracks** | 🗣 **Uitleggers**: geen terminal, scenariokaarten · 🛠 **Bouwers**: je eigen HTTPS-server en mTLS in de sandbox |
| **Voorkennis** | [01 · Crypto-basis](../01-crypto-basics/README.nl.md), of je bent al vertrouwd met "de private key blijft thuis, de public key reist" en "een certificaat is een ondertekende public key". Bouwers: de sandbox staat klaar, zie [Meedoen aan een cursus](../../joining.nl.md). |
| **Vervolg** | — |

## Na deze sessie kun je…

**Iedereen**

1. Uitleggen wat er gebeurt als iemand `https://shop.example` opent, en wat
   het hangslot wel en niet belooft.
2. De controles noemen die een client op een certificaat doet: keten, naam,
   datums, gebruik, en bewijs van de private key.
3. De bekende TLS-foutmeldingen herkennen en zeggen wie ze moet oplossen.
4. Uitleggen waarom certificaten steeds korter geldig zijn, straks nog maar 47
   dagen, en waarom vernieuwen daardoor geautomatiseerd moet worden.

**🗣 Uitleggers, daarnaast**

5. Een partner door de mTLS-onboarding loodsen: welke CA, welke bestanden
   welke kant op gaan, hoe namen gecontroleerd worden, en wie vernieuwt.

**🛠 Bouwers, daarnaast**

5. Een keten root → intermediate → server bouwen, een HTTPS-server draaien, die
   op de drie klassieke manieren stukmaken, mutual TLS toevoegen, en
   verloopdatums uitlezen.

## Programma

| Tijd | Onderdeel | Slides |
|------|-----------|--------|
| 0–3 | Opening: *"Er staat een hangslotje, dus het is veilig, toch?"* | 1–4 |
| 3–11 | **Deel 1 · HTTPS, stap voor stap**: DNS, de TLS 1.3-handshake, wat de browser controleert, wat het hangslot betekent | 5–11 |
| 11–17 | **Deel 2 · Ketens in het wild**: trust stores, de ontbrekende intermediate, namen, private CA's, TLS-inspectie | 12–17 |
| 17–22 | **Deel 3 · Mutual TLS**: de handshake, een partner aansluiten, serverconfiguratie | 18–22 |
| 22–27 | **Deel 4 · Levenscyclus**: certificaten van 47 dagen, automatisering, monitoring, intrekken, pinning, formaten, samenvatting | 23–31 |
| 27–43 | **Opdrachten**, kies je track | 32 |
| 43–50 | **Nabespreking**: foutmeldingen ontcijferd, en één scenariokaart | 33–34 |

## Materiaal

| | Voor | Wat |
|---|---|---|
| [slides.nl.qmd](slides.nl.qmd) | iedereen | de presentatie, met sprekersnotities (`S` in de browser) |
| [handout.nl.md](handout.nl.md) | iedereen, **print hem** | checklist voor livegang, checklist voor mTLS-onboarding, foutmeldingen ontcijferd |
| [cheatsheet.nl.md](cheatsheet.nl.md) | 🛠 | `openssl`- en `curl`-commando's voor HTTPS en mTLS |
| [exercises/tabletop-https-in-real-life.nl.md](exercises/tabletop-https-in-real-life.nl.md) | 🗣 | scenariokaarten, één set per tweetal |
| [exercises/01-https-in-the-wild.nl.md](exercises/01-https-in-the-wild.nl.md) … [05-bonus-expiry-and-formats.nl.md](exercises/05-bonus-expiry-and-formats.nl.md) | 🛠 | terminal-opdrachten; `check.sh` controleert je werk |
| [solutions/](solutions/tabletop-answers.md) | begeleider | antwoorden en bespreekpunten, Engels ([scenariokaarten](solutions/tabletop-answers.md), [bouwers](solutions/builders.md)) |

## Opdrachten

**🗣 Uitleggers** werken in tweetallen met de
[scenariokaarten](exercises/tabletop-https-in-real-life.nl.md). Doe er 3 à 4 van de 7.

**🛠 Bouwers** werken de opdrachten door. 2–4 zijn de kern (zo'n 15 min).
Voor 1 heb je internet nodig, die mag je overslaan; 5 is een bonus.

| # | Opdracht | Tijd |
|---|----------|------|
| 1 | [HTTPS in het wild](exercises/01-https-in-the-wild.nl.md) | 3 min |
| 2 | [Bouw een vertrouwensketen](exercises/02-build-a-chain.nl.md) | 4 min |
| 3 | [Je eigen HTTPS-server, en drie manieren om hem stuk te maken](exercises/03-your-own-https-server.nl.md) | 6 min |
| 4 | [Mutual TLS](exercises/04-mutual-tls.nl.md) | 5 min |
| 5 | [Bonus: verloopdatums en formaten](exercises/05-bonus-expiry-and-formats.nl.md) | 4 min |

Controleer je voortgang wanneer je wilt:

```shell
bash "$COURSES/courses/02-tls-and-pki/exercises/check.sh"
```

## Voor de begeleider

- **Een week vooraf:** stuur de uitnodiging met een link naar [Meedoen aan een cursus](../../joining.nl.md)
  (EN: [Joining a course](../../joining.md)).
- **Vooraf:** draai `make test`, print de hand-out en één set scenariokaarten
  per tweetal uitleggers. Check of er in de zaal internet is voor opdracht 1
  en voor een live `curl -v https://…` op het grote scherm.
- **Livedemo die goed werkt:** draai aan het eind van deel 1
  `curl -v https://www.example.com -o /dev/null` op het grote scherm en wijs
  de handshake-regels aan, het subject en de issuer van het certificaat, en de verloopdatum.
- **In deel 2 zitten de supporttickets.** Kom je tijd tekort, kort dan liever
  deel 4 in dan deel 2.
- **Nabespreking:** loop *Foutmeldingen ontcijferd* op de hand-out door. Vraag
  bij elke fout: "wie moet dit oplossen, wij of zij?". Laat daarna een tweetal
  uitleggers kaart 4 (mTLS-onboarding) presenteren.
- Antwoorden en bespreekpunten staan (in het Engels) in [solutions/](solutions/tabletop-answers.md).
