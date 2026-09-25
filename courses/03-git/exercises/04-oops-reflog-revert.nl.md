🇬🇧 [English](04-oops-reflog-revert.md) · 🇳🇱 Nederlands

# 🛠 4 · Oeps: reflog, revert en wat voorgoed vastligt

⏱ 5 min · **Doel:** "kwijtgeraakt" werk redden met de reflog, een fout op de
veilige manier ongedaan maken, en ontdekken waarom een verwijderd wachtwoord niet weg is.

## Stap 1: een enge fout

```bash
cd ~/lab/03/shop
git switch -q main
git log --oneline -4
git reset -q --hard HEAD~2
git log --oneline -4
```

De nieuwsbrief en de hotfix zijn weg van `main`. Of toch niet?

## Stap 2: de reflog weet het nog

De **reflog** is het dagboek van git: elke plek waar `HEAD` is geweest, op
**jouw** computer, zo'n 90 dagen lang.

```bash
git reflog -5
git reset -q --hard 'HEAD@{1}'
git log --oneline -4
```

`HEAD@{1}` betekent *"waar HEAD één stap geleden was"*. Alles is terug.

> 💡 De reflog beschermt alleen werk dat **gecommit** is. Wijzigingen die je
> niet gecommit had en met `reset --hard` weggooit, zijn echt weg.

## Stap 3: vooruit repareren (fix forward) met revert

Er komt een verkeerde prijs op `main`, en anderen hebben die misschien al
gepulld. Herschrijf de geschiedenis niet. Voeg een nieuwe commit toe die de
foute commit **ongedaan maakt**:

```bash
echo "Apples: FREE" > prices.txt
git commit -q -am "Update prices"
git revert --no-edit HEAD
cat prices.txt
git log --oneline -3
```

De geschiedenis vertelt nu het ware verhaal: de fout **en** de oplossing.
Niemand die tussendoor gepulld heeft, komt in de problemen.

## Stap 4: wat voorgoed vastligt

Iemand commit een wachtwoord, en haalt het in de volgende commit weer weg:

```bash
echo "DB_PASSWORD=hunter2" > config.env
git add config.env
git commit -q -m "Add config"
git rm -q config.env
git commit -q -m "Remove config"
ls
git log --oneline -S hunter2
git show HEAD~1:config.env
```

Het bestand is weg uit de nieuwste momentopname, maar **elke oudere
momentopname heeft het nog**. Iedereen die de repository gecloned heeft, heeft het wachtwoord.

## Stap 5 (optioneel): een verwijderde branch redden

Als je een branch verwijdert, vertelt git je waar die naar wees. Probeer het zelf:

```shell
git branch -D feature/opening-hours      # prints: Deleted branch … (was 1a2b3c4).
git branch feature/opening-hours 1a2b3c4  # use the hash git printed
```

## 🤔 Vragen

1. De reflog heeft je gered in stap 2. Zou hij ook een collega redden, op **diens** computer?
2. Waarom is `revert` op een gedeelde branch beter dan `reset` + force-push?
3. Het wachtwoord is naar een gedeelde repository gepusht. Wat moet er **eerst**
   gebeuren: de geschiedenis opschonen, of iets anders?

➡️ Bonus: [5 · Samenwerken en force-push](05-bonus-collaboration-force-push.nl.md)
