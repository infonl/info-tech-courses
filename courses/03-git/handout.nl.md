🇬🇧 [English](handout.md) · 🇳🇱 Nederlands

# Git op één pagina

*Hand-out bij cursus 03 · Git*

## Het beeld om te onthouden

Git is een **fotoalbum** van je project. Elke **commit** is een momentopname van
alle bestanden, met zijn **vingerafdruk** (hash) als naam, en hij wijst naar de
foto ervoor. **Branches** en **tags** zijn plakbriefjes op foto's; **HEAD** is *"je bent hier"*.

> **De gouden regel:** herschrijf nooit geschiedenis die iemand anders misschien al heeft.

## Veilig, voorzichtig, nooit

| | Commando's | Waarom |
|---|---|---|
| 🟢 **Altijd veilig** | `commit`, `branch`, `switch`, `merge`, `revert`, `fetch`, `pull`, `push`, `log`, `diff`, `tag` | Ze **voegen** alleen foto's **toe** of schuiven **jouw** labels vooruit |
| 🟡 **Alleen op je eigen branch, die je nog niet gedeeld hebt** | `rebase`, `commit --amend`, squash, `reset`, `push --force-with-lease` | Ze maken **nieuwe kopieën** en gooien de oude weg. Prima als niemand anders de oude heeft |
| 🔴 **Nooit op een gedeelde branch** (`main`, `release/*`, de branch van een collega) | `push --force`, `reset` van gepushte commits, geschiedenis herschrijven met `filter-repo` zonder het hele team | Werk van collega's verdwijnt, hun kopieën raken in de war, de audit trail is weg |

## Een pull request mergen: kies er één per team

| Knop | `main` krijgt | Kies als |
|---|---|---|
| **Merge commit** | alle commits + een merge commit | je de volledige, ware geschiedenis wilt |
| **Squash and merge** | één commit per pull request | je een nette geschiedenis wilt, één commit per wijziging, makkelijk terug te draaien |
| **Rebase and merge** | de commits, op een rechte lijn | elke commit op zichzelf betekenis heeft |

## Branching-strategieën

| Strategie | In het kort | Past bij |
|---|---|---|
| **Trunk-based** | piepkleine branches, dagelijks gemerged; onaf werk achter feature flags | continuous deployment, sterke CI |
| **GitHub flow** | kortlevende branch → pull request → `main` → deploy | de meeste webapps en SaaS |
| **Release branches** | `release/1.x` per ondersteunde versie; fixes worden gecherry-pickt | producten met meerdere ondersteunde versies |
| **GitFlow** | `develop`, `feature/*`, `release/*`, `hotfix/*` | releases met versienummers, grote teams. Vaak zwaarder dan nodig |

**Vuistregel:** kortlevende branches, vaak mergen.

## EHBO

| Oeps | Redding |
|---|---|
| "Ik heb een reset gedaan en mijn commits zijn weg" | `git reflog`, dan `git reset --hard HEAD@{1}` (of de hash die je nodig hebt) |
| "Ik heb een branch verwijderd" | Git liet `(was 1a2b3c4)` zien: `git branch <name> 1a2b3c4`. Of zoek hem op in `git reflog` |
| "Er staat een foute commit op `main`" | `git revert <hash>` → een nieuwe commit die hem ongedaan maakt. **Vooruit repareren** (fix forward), niet uitwissen |
| "Merge conflict!" | Open het bestand, kies tussen `<<<<<<<` en `>>>>>>>`, haal de markeringen weg, `git add`, `git commit`. Of `git merge --abort` |
| "Mijn push wordt geweigerd" | Iemand heeft eerder gepusht: `git pull --rebase`, dan `git push`. **Niet** `--force` |
| "Ik heb op de verkeerde branch gecommit" | `git switch -c right-branch` (neemt de commit mee), herstel daarna de oude branch. Vraag om hulp als het al gepusht is |

De reflog bestaat alleen op **jouw** computer en bewaart zo'n 90 dagen aan
**gecommit** werk. Wijzigingen die je niet gecommit hebt, zijn niet beschermd: commit vroeg en vaak.

## Er is een geheim gecommit

1. **Trek het geheim in en vervang het** (revoke and rotate), **nu**. Ga ervan uit dat het
   gelekt is: iedereen die gecloned heeft, heeft het, en bots scannen publieke
   repositories binnen een paar minuten
2. Laat het de eigenaar weten van het systeem waar het bij hoort
3. **Daarna** haal je het uit de code, en beslis je met het team of je de
   geschiedenis herschrijft (`git filter-repo`). Dat is opruimen, niet de oplossing
4. **Voorkomen:** `.gitignore` voor `.env` en keys, secret scanning op het platform, een secrets manager

## Een goede commit message

```text
Show opening hours on the contact page        ← what, in max ~50 characters

Customers kept calling to ask when we're open. ← why
Hours come from the same config as the footer.
Refs: SHOP-142                                 ← ticket
```
