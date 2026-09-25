🇬🇧 [English](02-branches-and-merges.md) · 🇳🇱 Nederlands

# 🛠 2 · Branches en merges

⏱ 5 min · **Doel:** branches maken, ze mergen op de twee manieren die git kent,
en een conflict oplossen.

## Stap 1: een fast-forward merge

Werk op een branch terwijl `main` niet verandert:

```bash
cd ~/lab/03/shop
git switch -q feature/prices
echo "Apples: 1 euro" > prices.txt
git add prices.txt
git commit -q -m "Add price list"
git switch -q main
git merge feature/prices
git log --oneline --graph --all
```

`Fast-forward`: er is niets nieuws gebeurd op `main`, dus git heeft het
**plakbriefje** `main` gewoon **doorgeschoven**. Er is geen nieuwe commit nodig.

## Stap 2: een echte merge

Deze keer gaat `main` ook verder terwijl de branch openstaat:

```bash
git switch -q -c feature/opening-hours
echo "Open 9-17" > hours.txt
git add hours.txt
git commit -q -m "Add opening hours"
git switch -q main
echo "Welcome to the shop" >> README.md
git commit -q -am "Welcome text"
git merge --no-edit feature/opening-hours
git log --oneline --graph --all
git cat-file -p HEAD | head -4
```

De merge commit heeft **twee parents**: hij voegt beide lijnen van werk samen.

## Stap 3: wat is er veranderd? Diffs

Git slaat momentopnames op, en **berekent** de verschillen als je erom vraagt:

```bash
git diff HEAD~2 HEAD
git show --stat HEAD~1
```

## Stap 4: een conflict

Twee branches veranderen **dezelfde regel**. Git kan niet beslissen wie gelijk heeft, dus vraagt het jou.

```bash
git switch -q -c feature/cheaper
sed -i 's/1 euro/80 cents/' prices.txt
git commit -q -am "Cheaper apples"
git switch -q main
sed -i 's/1 euro/1.20 euro/' prices.txt
git commit -q -am "Pricier apples"
git merge feature/cheaper
cat prices.txt
```

```text
<<<<<<< HEAD
Apples: 1.20 euro
=======
Apples: 80 cents
>>>>>>> feature/cheaper
```

Het team besluit: de prijs blijft 1 euro. Leg dat besluit vast en maak de merge af:

```bash
echo "Apples: 1 euro" > prices.txt
git add prices.txt
git commit -q --no-edit
git log --oneline --graph -6
```

## 🤔 Vragen

1. Waarom maakte stap 1 geen merge commit, en stap 2 wel?
2. Was een van beide versies in het conflict "fout"? Wie zou in het echt moeten beslissen?
3. `git diff` werkt tussen **elke** twee commits. Hoe kan dat, als git momentopnames opslaat in plaats van wijzigingen?

➡️ Volgende: [3 · Je eigen geschiedenis herschrijven](03-rebase-squash-cherry-pick.nl.md)
