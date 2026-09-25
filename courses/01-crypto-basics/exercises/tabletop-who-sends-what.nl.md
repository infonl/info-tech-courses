🇬🇧 [English](tabletop-who-sends-what.md) · 🇳🇱 Nederlands

# 🗣 Scenariokaarten: wie stuurt wat?

⏱ 15–17 min · **In tweetallen.** Je hebt geen terminal nodig; houd de
[handout](../handout.nl.md) bij de hand.

**Zo werkt het:** lees een kaart en beantwoord samen de vragen. Schrijf of teken
**wie welk bestand naar wie stuurt**, met pijlen tussen de partijen. Kaart 1–2
zijn opwarmers. Kies daarna zelf uit 3–7. Zorg dat je in de nabespreking één
kaart kunt presenteren.

**De enige regel die je nodig hebt:** *de private key (de geheime sleutel die je
nooit deelt) blijft thuis, de public key (de sleutel die je gerust mag delen)
gaat op reis.*

---

## Kaart 1 · Het ondertekende contract (opwarmer)

Alice ondertekent (signs) een contract digitaal en stuurt het naar Bob.

1. Welke sleutel gebruikt Alice om te ondertekenen?
2. Wat heeft Bob nodig om de handtekening (signature) te controleren, en waar
   haalt hij dat vandaan?
3. Welk bestand mag Alice nooit meesturen?
4. Kan iemand anders het contract lezen?

---

## Kaart 2 · Het vertrouwelijke bestand (opwarmer)

Bob wil Alice een bestand sturen dat alleen zij kan openen.

1. Wiens sleutel gebruikt Bob om het bestand op slot te doen: die van hemzelf of
   die van Alice? Private of public?
2. Wat moet Alice van tevoren naar Bob sturen?
3. Mallory onderschept dat bericht en verruilt het voor haar eigen public key.
   Wat gebeurt er? Hoe had Bob dat kunnen merken?

---

## Kaart 3 · Onze webshop (ServerAuth, publieke CA)

We hosten `shop.example` voor een klant. Het certificaat (certificate) komt van
een publieke CA (certificaatautoriteit, "de notaris") die elke browser
vertrouwt.

1. Wie maakt het sleutelpaar (key pair)? Waar staat de private key?
2. Wat gaat er naar de CA, en wat komt er terug?
3. Wat moeten bezoekers van de shop doen of installeren om hem te vertrouwen?
4. Een bezoeker meldt "certificaat niet vertrouwd", maar alleen op een paar
   oudere telefoons. Wat is een waarschijnlijke oorzaak aan *onze* kant?

---

## Kaart 4 · De interne API (ServerAuth, private CA)

We draaien `api.internal.example` voor een partner. Het certificaat komt van
**onze eigen private CA**. De developer van de partner mailt: *"Jullie
certificaat wordt niet vertrouwd. Kunnen jullie ons het certificaat en de key
sturen, dan voegen wij die toe?"*

1. Wat heeft de partner eigenlijk van ons nodig?
2. Is dat veilig om te sturen? Per e-mail?
3. Wat antwoord je op het stukje "en de key"?
4. De partner stelt voor om de certificaatcontrole "even" uit te zetten. Wat is
   het risico?

---

## Kaart 5 · Acme roept onze API aan (ClientAuth / mutual TLS)

Acme BV gaat onze API aanroepen. We willen zeker weten dat **alleen Acme** dat
kan, dus we eisen een client-certificaat (mTLS, wederzijdse TLS: ook de client
laat een certificaat zien). Publieke CA's geven geen ClientAuth-certificaten
meer uit.

1. Wie maakt het sleutelpaar van Acme?
2. Optie A: *onze* private CA geeft het certificaat van Acme uit. Teken de
   pijlen. Welke bestanden gaan heen en weer, en in welke richting?
3. Optie B: Acme heeft een *eigen* CA. Welk(e) bestand(en) hebben we van Acme
   nodig?
4. Waarmee moet onze server worden ingesteld, bij allebei de opties?
5. Onze projectmanager biedt aan: *"Het is makkelijker als wij de key en het
   certificaat voor Acme maken en die even opmailen."* Wat is daar mis mee,
   naast die e-mail?

---

## Kaart 6 · De behulpzame e-mail

Een leverancier die een monitoringtool op *zijn eigen* systemen installeert,
schrijft:

> *"Om verbinding te maken met jullie omgeving, willen we graag het
> `.pfx`-bestand van jullie productiecertificaat en het bijbehorende wachtwoord
> ontvangen. We bewaren het veilig."*

1. Wat zit er in een `.pfx`?
2. Wat kan de leverancier daarmee?
3. Wat hebben ze waarschijnlijk echt nodig? Wat kun je in plaats daarvan
   aanbieden?
4. Is er een situatie waarin je een `.pfx` *wel* mag afgeven?

---

## Kaart 7 · Verloopvrijdag (bonus)

Op maandag blijkt dat het client-certificaat van Acme vrijdag verloopt. Acme
stuurt ons een nieuw certificaat van dezelfde CA.

1. Wie moet er iets doen: Acme, wij, of allebei?
2. Wat moeten we aan onze kant aanpassen als we de **CA** van Acme vertrouwen?
3. En als we de **vingerafdruk (fingerprint) van het oude certificaat** van Acme
   hadden vastgepind?
4. Hoe voorkomen we de volgende keer deze vrijdagpaniek?
