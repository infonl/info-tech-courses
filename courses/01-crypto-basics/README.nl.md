🇬🇧 [English](README.md) · 🇳🇱 Nederlands

# 01 · Crypto-basis: sloten, sleutels, zegels & paspoorten

| | |
|---|---|
| **Duur** | 45–50 min |
| **Doelgroep** | Iedereen die op het werk te maken heeft met "certificaten", "keys" of "SSL", of je het nu zelf inricht of aan een klant moet uitleggen |
| **Tracks** | 🗣 **Uitleggers**: geen terminal, scenariokaarten · 🛠 **Bouwers**: terminal-opdrachten in de sandbox |
| **Voorbereiding** | Uitleggers: niets, neem een pen mee. Bouwers: de sandbox staat open en `tools/ready.sh` is helemaal groen (zie [Meedoen aan een cursus](../../joining.nl.md)). |
| **Vervolg** | [02 · TLS & PKI in de praktijk](../02-tls-and-pki/README.nl.md) |

## Na deze sessie kun je…

**Iedereen**

1. De drie taken van crypto noemen: iets **geheim** houden, **knoeien**
   zichtbaar maken, en aantonen **wie** je voor je hebt.
2. De gouden regel uitleggen, *de private key blijft thuis, de public key
   reist*, en een verzoek herkennen dat die regel breekt.
3. Zeggen welke bestanden je veilig kunt mailen (certificaat, CSR,
   CA-certificaat) en welke nooit (private key, `.p12`/`.pfx`).

**🗣 Uitleggers, daarnaast**

4. Bij een ServerAuth- of ClientAuth-opzet (mTLS) zeggen wie het sleutelpaar
   maakt, wie het certificaat ondertekent en wie welk CA-certificaat nodig heeft.

**🛠 Bouwers, daarnaast**

4. Met `openssl` RSA-, EC- en Ed25519-sleutels maken, PEM ↔ DER omzetten, een
   bestand ondertekenen en controleren, en een certificaat uitgeven met je eigen mini-CA.

## Programma

| Tijd | Onderdeel | Slides |
|------|-----------|--------|
| 0–3 | Opening: *"Kun je ons even het certificaat, de key en het wachtwoord sturen?"*, drie taken van crypto | 1–4 |
| 3–10 | **Deel 1 · Geheimen & vingerafdrukken**: hash, gedeelde sleutel, AEAD | 5–8 |
| 10–18 | **Deel 2 · Sleutelparen**: hangsloten, lakzegels, verf mengen, RSA vs EC | 9–15 |
| 18–26 | **Deel 3 · Vertrouwen**: certificaten, CA's, wie heeft wat nodig, veilige bestanden, rode vlaggen, de mail beantwoorden | 16–26 |
| 26–43 | **Opdrachten**, kies je track | 27 |
| 43–50 | **Nabespreking**: één scenariokaart, met z'n allen | 28 |

## Materiaal

| | Voor | Wat |
|---|---|---|
| [slides.nl.qmd](slides.nl.qmd) | iedereen | de presentatie, met sprekersnotities (`S` in de browser) |
| [handout.nl.md](handout.nl.md) | iedereen, **print hem** | één pagina: gouden regel, welke bestanden veilig zijn, wie heeft wat nodig, rode vlaggen, vragen voor derde partijen |
| [cheatsheet.nl.md](cheatsheet.nl.md) | 🛠 | de `openssl`-commando's uit de opdrachten |
| [exercises/tabletop-who-sends-what.nl.md](exercises/tabletop-who-sends-what.nl.md) | 🗣 | scenariokaarten, één set per tweetal |
| [exercises/01-fingerprints.nl.md](exercises/01-fingerprints.nl.md) … [05-bonus-your-own-ca.nl.md](exercises/05-bonus-your-own-ca.nl.md) | 🛠 | terminal-opdrachten; `check.sh` controleert je werk |
| [solutions/](solutions/tabletop-answers.md) | begeleider | antwoorden en bespreekpunten, Engels ([scenariokaarten](solutions/tabletop-answers.md), [bouwers](solutions/builders.md)) |

## Opdrachten

**🗣 Uitleggers** werken in tweetallen met de
[scenariokaarten](exercises/tabletop-who-sends-what.nl.md). Kaart 1–2 zijn
opwarmers, 3–7 zijn situaties uit echte projecten. Doe er 3 à 4.

**🛠 Bouwers** werken de opdrachten door. 1–4 zijn de kern (zo'n 15 min); 5 is een bonus.

| # | Opdracht | Tijd |
|---|----------|------|
| 1 | [Vingerafdrukken](exercises/01-fingerprints.nl.md) | 3 min |
| 2 | [Eén gedeelde sleutel](exercises/02-one-shared-key.nl.md) | 4 min |
| 3 | [Sleutelparen, PEM & DER](exercises/03-key-pairs.nl.md) | 5 min |
| 4 | [Ondertekenen & controleren](exercises/04-sign-and-verify.nl.md) | 4 min |
| 5 | [Bonus: wees je eigen notaris (CA)](exercises/05-bonus-your-own-ca.nl.md) | 5 min |

Controleer je voortgang wanneer je wilt:

```shell
bash "$COURSES/courses/01-crypto-basics/exercises/check.sh"
```

## Voor de begeleider

- **Een week vooraf:** stuur de uitnodiging met een link naar [Meedoen aan een cursus](../../joining.nl.md)
  (EN: [Joining a course](../../joining.md)), zodat bouwers `tools/ready.sh` alvast kunnen draaien.
- **Vooraf:** open de sandbox zelf en draai `make test`. Print de hand-out voor
  iedereen en één set scenariokaarten per tweetal uitleggers.
- **Vraag bij de start** wie er op welke manier met certificaten te maken
  heeft. Laat mensen zelf hun track kiezen; gemengde tweetallen (een bouwer en
  een uitlegger samen aan de kaarten) werken ook goed.
- **Bewaak de tijd voor deel 3.** Dat is voor uitleggers het belangrijkste
  deel, dus verlies geen tijd aan RSA-wiskunde in deel 2.
- **Nabespreking:** neem kaart 5 (Acme belt onze API aan) of 6 (de behulpzame
  mail) en laat één tweetal uitleggers die presenteren. Vraag de bouwers welke
  bestanden uit hun lab-map waarheen zouden reizen. Sluit af door iemand die
  nog niets heeft gezegd de openingsmail (slide 2) in eigen woorden te laten beantwoorden.
- Veelgestelde vragen staan (in het Engels) in [solutions/tabletop-answers.md](solutions/tabletop-answers.md).
