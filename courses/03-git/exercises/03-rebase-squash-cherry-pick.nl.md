🇬🇧 [English](03-rebase-squash-cherry-pick.md) · 🇳🇱 Nederlands

# 🛠 3 · Rebase, squash en cherry-pick

⏱ 5 min · **Doel:** **je eigen** branch opruimen voordat je hem deelt, en één
fix naar een andere branch kopiëren. Let op de hashes: elke keer dat je
herschrijft, ontstaan er **nieuwe** commits.

## Stap 1: een rommelige feature branch

```bash
cd ~/lab/03/shop
git switch -q -c feature/newsletter
echo "Sign up for our newsletter" > newsletter.txt
git add newsletter.txt
git commit -q -m "Add newsletter"
echo "Every month" >> newsletter.txt
git commit -q -am "wip"
echo "Unsubscribe any time" >> newsletter.txt
git commit -q -am "fix typo"
git log --oneline -3 | tee ../before-rebase.txt
```

Intussen voegt een collega iets toe aan `main`:

```bash
git switch -q main
echo "Closed on Sundays" >> hours.txt
git commit -q -am "Sunday closing"
git log --oneline --graph --all -8
```

## Stap 2: rebase, mijn werk opnieuw afspelen bovenop de nieuwe main

```bash
git switch -q feature/newsletter
git rebase main
git log --oneline -3
cat ../before-rebase.txt
git log --oneline --graph --all -8
```

Dezelfde messages, dezelfde wijzigingen, maar **andere hashes**: rebase heeft
**kopieën** gemaakt bovenop de nieuwe `main`. De oude commits bestaan (voorlopig)
nog, maar er wijst niets meer naar.

## Stap 3: squash, drie commits worden er één

Dit doet de knop *"Squash and merge"* op een platform:

```bash
git switch -q main
git merge --squash feature/newsletter
git commit -q -m "Add newsletter sign-up (#12)"
git log --oneline -3
```

`main` krijgt **één** nette commit; de commits `wip` en `fix typo` komen niet in de geschiedenis van main.

Het interactieve alternatief op je eigen branch: `git rebase -i main` opent een
editor waarin je commits kunt squashen, een nieuwe message kunt geven en van volgorde kunt veranderen.

## Stap 4: een hotfix cherry-picken naar een release

Versie 1.0 (de tag uit opdracht 1) draait in productie. Een fix die op `main`
gemaakt is, is daar ook dringend nodig, maar **zonder** al het andere nieuwe werk uit `main`:

```bash
echo "Contact: shop@example.com" > CONTACT.txt
git add CONTACT.txt
git commit -q -m "Hotfix: add contact address"
git switch -q -c release/1.0 v1.0
git cherry-pick main
git log --oneline
ls
```

`release/1.0` heeft nu de hotfix, maar niet de prijslijst of de nieuwsbrief.

## 🤔 Vragen

1. Waarom hebben de commits na de rebase nieuwe hashes? (Denk aan opdracht 1:
   wat zit er in een commit?)
2. Rebase heeft de geschiedenis veranderd. Waarom was dat hier goed? Wanneer zou
   het **niet** goed zijn?
3. De gecherry-pickte commit op `release/1.0` heeft een andere hash dan het
   origineel op `main`. Waarom?
4. Wat verlies je met *squash and merge*? Wat win je?

➡️ Volgende: [4 · Oeps: reflog, revert en wat voorgoed vastligt](04-oops-reflog-revert.nl.md)
