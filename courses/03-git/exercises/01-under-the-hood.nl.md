🇬🇧 [English](01-under-the-hood.md) · 🇳🇱 Nederlands

# 🛠 1 · Onder de motorkap: foto's en plakbriefjes

⏱ 4 min · **Doel:** zien dat een commit een momentopname is met zijn
vingerafdruk als naam, en dat branches en tags gewoon labels zijn die ernaar wijzen.

## Stap 1: een nieuwe repository

```bash
mkdir -p ~/lab/03 && cd ~/lab/03
git init -q -b main shop && cd shop
git config user.name "Alice" && git config user.email "alice@example.com"
echo "hello" > README.md
git add README.md
git commit -q -m "Add README"
git log --oneline
```

## Stap 2: alles heeft zijn vingerafdruk als naam

Git geeft elk stukje inhoud zijn hash als naam, net als de vingerafdrukken in cursus 01.
Dezelfde inhoud krijgt dezelfde naam, op elke computer ter wereld:

```bash
git hash-object README.md
```

```text
ce013625030ba8dba906f756967f9e9ca394464a
```

Kijk nu in de commit, daarna in de momentopname van de map (de *tree*) waar
hij naar wijst, en ten slotte in de inhoud van het bestand (de *blob*):

```bash
git cat-file -p HEAD
git cat-file -p 'HEAD^{tree}'
git cat-file -p ce01362
```

De commit is een klein stukje tekst: *welke tree*, *wie*, *wanneer*, *waarom*.
Vanaf de tweede commit staat er ook in *welke parent* (de vorige commit).

## Stap 3: een tweede foto

```bash
echo "We sell apples" >> README.md
git commit -q -am "Say what we sell"
git cat-file -p HEAD
```

Let op de regel `parent`: elke commit wijst naar de commit ervoor. Verander
iets in een oude commit, en de hash verandert, en daarmee ook elke hash die
erna komt. Daardoor zie je het meteen als er met de geschiedenis geknoeid is.

## Stap 4: branches en tags zijn plakbriefjes

```bash
cat .git/HEAD
cat .git/refs/heads/main
git branch feature/prices
git tag v1.0 HEAD~1
cat .git/refs/heads/feature/prices .git/refs/tags/v1.0
git log --oneline --decorate --all
```

Een branch is een piepklein bestand met één commit-hash erin: een plakbriefje
op een foto. `HEAD` is de pijl *"je bent hier"*, die wijst naar de branch waar je op zit.

## 🤔 Vragen

1. Je collega draait `git hash-object` op een bestand waar precies `hello` in staat.
   Krijgt die dezelfde hash? Waarom is dat belangrijk?
2. Hoe groot is een branch, in bytes? Wat zegt dat over wat het kost om er een te maken?
3. Wat is het verschil tussen de branch `feature/prices` en de tag `v1.0`?
   (Tip: wat gebeurt er met elk van beide als je een nieuwe commit maakt?)

➡️ Volgende: [2 · Branches en merges](02-branches-and-merges.nl.md)
