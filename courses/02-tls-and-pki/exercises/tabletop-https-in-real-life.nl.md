🇬🇧 [English](tabletop-https-in-real-life.md) · 🇳🇱 Nederlands

# 🗣 Scenariokaarten: HTTPS in het echt

⏱ 15 min · **In tweetallen.** Je hebt geen terminal nodig; houd de
[hand-out](../handout.nl.md) met de checklists en *Foutmeldingen ontcijferd*
bij de hand.

**Zo werkt het:** kies 3 à 4 kaarten. Beantwoord per kaart: **wat is er aan de
hand**, **wie moet in actie komen** (wij, zij, een leverancier), en **wat zou je
terugschrijven**, in twee of drie zinnen. Zorg dat je in de nabespreking één
kaart kunt presenteren.

---

## Kaart 1 · Het hangslot

Een klant schrijft: *"We hebben het partnerportaal `portal-acme-support.com`
bekeken dat jullie ons stuurden. Er staat een hangslotje, dus het is veilig,
toch?"* Het echte domein van de partner is `acme.example`.

1. Wat bewijst het hangslot hier? Wat bewijst het niet?
2. Wat zou je controleren voordat je "ja" zegt?
3. Hoe leg je dat de klant uit zonder vaktaal?

---

## Kaart 2 · "Het werkt in mijn browser"

We hebben `api.shop.example` live gezet. De Java-applicatie van een partner
meldt `PKIX path building failed`. Onze developer zegt: *"In Chrome werkt het
prima, dus het ligt aan hen."*

1. Wat is de meest waarschijnlijke oorzaak? (Tip: *Foutmeldingen ontcijferd*.)
2. Wie lost het op, wij of de partner?
3. Waarom laat Chrome het probleem niet zien?

---

## Kaart 3 · Het nieuwe domein

Marketing verhuist de shop van `shop.example` naar `www.shop.example` en voegt
`shop.example.nl` toe. De volgende ochtend krijgen sommige gebruikers een
certificaatwaarschuwing.

1. Wat is er mis met het certificaat?
2. Wat moet er aangevraagd worden, en wie moeten erbij betrokken worden?
3. Had een wildcard `*.shop.example` dit kunnen voorkomen? Voor alle drie de namen?

---

## Kaart 4 · Acme aansluiten op mTLS

Acme gaat onze API aanroepen met een clientcertificaat. Hun projectmanager
vraagt: *"Wat hebben jullie precies van ons nodig, en wat krijgen wij van
jullie?"*

1. Kies een CA-model (dat van ons of dat van hen) en leg je keuze uit.
2. Zet de stappen op volgorde, en wie elke stap doet. Gebruik de checklist op
   de hand-out.
3. Acme stelt voor: *"koop gewoon een clientcertificaat bij een publieke CA,
   dat is het makkelijkst"*. Wat antwoord je?
4. Hoe zorgen we ervoor dat de CSR echt van Acme komt?

---

## Kaart 5 · Het CDN en de private key

We zetten de shop achter een CDN / hostingpartij die HTTPS afhandelt. Hun
aanmeldformulier vraagt ons om *"je certificaat en private key te uploaden"*.

1. Is dit een rode vlag, of redelijk? Waarom?
2. Welk alternatief bieden de meeste CDN's en platforms?
3. Als we de key toch uploaden: wat verandert er aan wie we moeten vertrouwen,
   en wat leggen we vast?

---

## Kaart 6 · 47 dagen

De certificaten van een klant worden één keer per jaar met de hand vernieuwd,
door één systeembeheerder. Publieke certificaten zijn binnenkort nog maar
maximaal 200 dagen geldig, daarna 100, daarna 47.

1. Wat gebeurt er met deze manier van werken?
2. Wat raad je aan, in gewone taal?
3. Welke drie vragen zou je hun hostingleverancier stellen?

---

## Kaart 7 · Het vastgepinde certificaat (bonus)

De mobiele app van een partner **pint** het certificaat van onze API. Ons
certificaat wordt elke 60 dagen automatisch vernieuwd. Na de laatste
vernieuwing werkte de app voor niemand meer.

1. Wat is er gebeurd?
2. Snelle oplossing voor nu, en wie doet die?
3. Hoe voorkom je dat het nog eens gebeurt, zonder het automatisch vernieuwen
   op te geven?
