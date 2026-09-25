🇬🇧 [English](tabletop-git-in-a-team.md) · 🇳🇱 Nederlands

# 🗣 Scenariokaarten: git in een team

⏱ 15 min · **In tweetallen.** Je hebt geen terminal nodig; houd de [hand-out](../handout.nl.md) bij de hand.

**Zo werkt het:** kies 3 à 4 kaarten. Beantwoord per kaart: **wat is er aan de
hand**, **wat moet er nu gebeuren**, en **wat moet het team afspreken** zodat
het niet nog eens gebeurt. Zorg dat je in de nabespreking één kaart kunt presenteren.

**De regel die je het vaakst nodig hebt:** *herschrijf nooit geschiedenis die iemand anders misschien al heeft.*

---

## Kaart 1 · De vrijdagrelease

Vrijdag 16:30. In de release die een uur geleden live ging, zit een bug. Een
developer stelt voor: *"Ik reset `main` naar gisteren en force-push, dan deployen we opnieuw."*
Drie collega's hebben sinds vanochtend `main` gepulld.

1. Wat gaat er mis met dit voorstel, en voor wie?
2. Wat is het veiligere alternatief? Hoe ziet de geschiedenis er daarna uit?
3. Wat vertel je de klant over wat er gebeurd is, en hoe kun je dat laten zien?

---

## Kaart 2 · Het gelekte wachtwoord

Een developer heeft het wachtwoord van de productiedatabase in de repository
gecommit en gepusht. Tien minuten later heeft die het in een nieuwe commit
weggehaald: *"Opgelost, het is weg."*

1. Is het weg? Waarom (niet)?
2. Wat moet er **eerst** gebeuren, en wie moet dat doen?
3. Wat regel je zodat dit niet nog eens gebeurt?

---

## Kaart 3 · De hotfix midden in een grote feature

Versie 2.3 draait in productie. Op `main` staat al half af werk voor 2.4. In
productie wordt een kritieke bug gevonden.

1. Hoe krijg je een fix in productie **zonder** het onafgemaakte werk voor 2.4?
2. Hoe zorg je dat de fix niet kwijtraakt voor 2.4?
3. Wat had dit makkelijker gemaakt? (Tip: branching-strategie, feature flags.)

---

## Kaart 4 · Squashen of niet?

Het team heeft discussie over de *"merge"*-knop. De ene developer wil elke
commit bewaren; de andere wil één commit per pull request. De klant eist dat
elke wijziging op `main` terug te voeren is op een ticket.

1. Wat zijn de voor- en nadelen van **merge commit** tegenover **squash and merge**?
2. Wat zou jij hier kiezen, en waarom?
3. Wat zet je in de werkafspraken van het team?

---

## Kaart 5 · De branch van drie maanden

Een feature branch staat al drie maanden open. Als je hem in `main` merget,
krijg je honderden conflicten. De developer vraagt een week om *"de merge uit te zoeken"*.

1. Hoe is het zo ver gekomen?
2. Welke opties zijn er nu?
3. Wat zou je adviseren voor de volgende grote feature?

---

## Kaart 6 · "Wie heeft dit veranderd, en waarom?"

Een auditor vraagt: *"Wie heeft in maart de kortingsberekening veranderd, wie
heeft dat goedgekeurd, en waarom?"*

1. Waar in git en op het platform vind je de antwoorden?
2. Welke gewoontes in het team maken deze vraag makkelijk, en welke maken hem onmogelijk?
3. Iemand heeft in april `main` geforce-pusht. Wat betekent dat voor de audit?

---

## Kaart 7 · Een branching-strategie kiezen (bonus)

Er starten twee nieuwe projecten:
**A**: een webshop die meerdere keren per dag naar productie deployt.
**B**: een product dat bij 40 klanten geïnstalleerd is, waarbij elke klant met
een supportcontract tot twee jaar op een oudere versie mag blijven.

1. Welke branching-strategie past bij elk project? Waarom?
2. Hoe komt een bugfix in project B in alle ondersteunde versies terecht?
3. Wat moet het platform in allebei de projecten afdwingen?
