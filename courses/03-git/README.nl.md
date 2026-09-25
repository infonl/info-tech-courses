🇬🇧 [English](README.md) · 🇳🇱 Nederlands

# 03 · Git: een tijdmachine van plakbriefjes

| | |
|---|---|
| **Duur** | 45–50 min |
| **Doelgroep** | Iedereen die met code, configuratie of documentatie in git werkt, of samenwerkt met mensen die dat doen: developers, testers, designers, projectmanagers, releasemanagers |
| **Tracks** | 🗣 **Uitleggers**: geen terminal, scenariokaarten · 🛠 **Bouwers**: git in de sandbox |
| **Voorkennis** | Geen. Handig: het idee van een vingerafdruk (hash) uit [01 · Crypto-basis](../01-crypto-basics/README.nl.md). Bouwers: de sandbox staat klaar, zie [Meedoen aan een cursus](../../joining.nl.md). |
| **Vervolg** | — |

## Na deze sessie kun je…

**Iedereen**

1. Uitleggen waarom git bestaat, wat er vóór git was, en waarom git gewonnen heeft.
2. Uitleggen dat git bestaat uit **foto's met hun vingerafdruk als naam**, en dat
   branches, tags en `HEAD` gewoon **labels** zijn die ernaar wijzen.
3. Branches, merges, rebase, squash, cherry-pick en pull/merge requests in
   gewone taal uitleggen, en een merge-strategie en een branching-strategie kiezen.
4. De gouden regel uitleggen, *herschrijf nooit geschiedenis die iemand anders
   misschien al heeft*, en waarom die betekent: **vooruit repareren** (fix forward) en **geen
   force-push op gedeelde branches**.
5. Zeggen wat je als eerste doet als er een geheim (wachtwoord, key) is gecommit.

**🗣 Uitleggers, daarnaast**

6. Een team adviseren over branching- en merge-strategie, en over de aanpak
   van een foute release of een gelekt geheim, zonder een terminal aan te raken.

**🛠 Bouwers, daarnaast**

6. In commits kijken, mergen en een conflict oplossen, rebasen, squashen,
   cherry-picken, werk redden met de reflog, reverten, en zien wat `--force` met een team doet.

## Programma

| Tijd | Onderdeel | Slides |
|------|-----------|--------|
| 0–3 | Opening: *"Ik force-push main even om het op te schonen"*, en git in één slide | 1–4 |
| 3–9 | **Deel 1 · Waarom git**: vóór git, de voorgangers, waarom git won | 5–8 |
| 9–15 | **Deel 2 · Onder de motorkap**: foto's, vingerafdrukken, labels, diffs, remotes | 9–14 |
| 15–22 | **Deel 3 · Samenwerken**: branch, merge, conflicten, rebase, squash, cherry-pick, pull requests, strategieën | 15–23 |
| 22–27 | **Deel 4 · Voorgoed vastgelegd**: de gouden regel, force-push, vooruit repareren, reflog, geheimen, audit trail | 24–32 |
| 27–43 | **Opdrachten**, kies je track | 33 |
| 43–50 | **Nabespreking**: één scenariokaart, met z'n allen | 34 |

## Materiaal

| | Voor | Wat |
|---|---|---|
| [slides.nl.qmd](slides.nl.qmd) | iedereen | de presentatie, met sprekersnotities (`S` in de browser) |
| [handout.nl.md](handout.nl.md) | iedereen, **print hem** | veilige en gevaarlijke commando's, merge- en branching-strategieën, EHBO, wat te doen bij een gelekt geheim |
| [cheatsheet.nl.md](cheatsheet.nl.md) | 🛠 | de git-commando's uit de opdrachten, en meer |
| [exercises/tabletop-git-in-a-team.nl.md](exercises/tabletop-git-in-a-team.nl.md) | 🗣 | scenariokaarten, één set per tweetal |
| [exercises/01-under-the-hood.nl.md](exercises/01-under-the-hood.nl.md) … [05-bonus-collaboration-force-push.nl.md](exercises/05-bonus-collaboration-force-push.nl.md) | 🛠 | terminal-opdrachten; `check.sh` controleert je werk |
| [solutions/](solutions/tabletop-answers.md) | begeleider | antwoorden en bespreekpunten, Engels ([scenariokaarten](solutions/tabletop-answers.md), [bouwers](solutions/builders.md)) |

## Opdrachten

**🗣 Uitleggers** werken in tweetallen met de
[scenariokaarten](exercises/tabletop-git-in-a-team.nl.md). Doe er 3 à 4 van de 7.

**🛠 Bouwers** werken de opdrachten op volgorde door; ze gaan allemaal verder
in dezelfde repository. 1–4 zijn de kern (zo'n 18 min); 5 is een bonus.

| # | Opdracht | Tijd |
|---|----------|------|
| 1 | [Onder de motorkap: foto's en plakbriefjes](exercises/01-under-the-hood.nl.md) | 4 min |
| 2 | [Branches en merges](exercises/02-branches-and-merges.nl.md) | 5 min |
| 3 | [Rebase, squash en cherry-pick](exercises/03-rebase-squash-cherry-pick.nl.md) | 5 min |
| 4 | [Oeps: reflog, revert en wat voorgoed vastligt](exercises/04-oops-reflog-revert.nl.md) | 5 min |
| 5 | [Bonus: samenwerken, en waarom je nooit een gedeelde branch force-pusht](exercises/05-bonus-collaboration-force-push.nl.md) | 5 min |

Controleer je voortgang wanneer je wilt:

```shell
bash "$COURSES/courses/03-git/exercises/check.sh"
```

## Voor de begeleider

- **Een week vooraf:** stuur de uitnodiging met een link naar [Meedoen aan een cursus](../../joining.nl.md)
  (EN: [Joining a course](../../joining.md)).
- **Vooraf:** draai `make test`, print de hand-out en één set scenariokaarten per tweetal uitleggers.
- **Livedemo die goed werkt:** doe aan het eind van deel 2 stap 2–4 van
  opdracht 1 op het grote scherm. Dat `cat .git/refs/heads/main` maar één regel
  tekst laat zien, is voor veel mensen het "aha"-moment.
- **Deel 4 hebben mensen het hardst nodig.** Kom je tijd tekort, kort dan de
  geschiedenis in deel 1 in, niet de gouden regel.
- **Nabespreking:** kaart 1 (de vrijdagrelease) of kaart 2 (het gelekte
  wachtwoord) werkt goed met iedereen. Vraag de bouwers wat ze zouden typen, en
  de uitleggers wat ze aan de klant zouden schrijven.
- Antwoorden en bespreekpunten staan (in het Engels) in [solutions/](solutions/tabletop-answers.md).
