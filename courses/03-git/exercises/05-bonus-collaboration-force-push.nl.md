🇬🇧 [English](05-bonus-collaboration-force-push.md) · 🇳🇱 Nederlands

# 🛠 5 · Bonus: samenwerken, en waarom je nooit een gedeelde branch force-pusht

⏱ 5 min · **Doel:** een team nabootsen met een gedeelde repository, zien waarom
git sommige pushes weigert, en wat `--force` echt doet.

## Stap 1: een gedeelde repository en twee collega's

`origin.git` speelt de rol van GitHub of GitLab. Alice en Bob maken er allebei een clone van.

```bash
cd ~/lab/03
git init -q --bare -b main origin.git
git clone -q origin.git alice 2>/dev/null
git clone -q origin.git bob 2>/dev/null
git -C alice config user.name "Alice" && git -C alice config user.email "alice@example.com"
git -C bob config user.name "Bob" && git -C bob config user.email "bob@example.com"
```

## Stap 2: Alice begint, Bob voegt iets toe

```bash
cd ~/lab/03/alice
echo "# Team shop" > README.md
git add README.md && git commit -q -m "Start"
git push -q origin main
cd ~/lab/03/bob
git pull -q origin main
echo "Bob's idea" > bob.txt
git add bob.txt && git commit -q -m "Bob's idea"
git push -q origin main
```

## Stap 3: Alice pusht zonder eerst te pullen

```bash
cd ~/lab/03/alice
echo "Alice's idea" > alice.txt
git add alice.txt && git commit -q -m "Alice's idea"
git push origin main
```

```text
 ! [rejected]        main -> main (fetch first)
```

Git beschermt het werk van Bob: met de push van Alice zou zijn commit weggegooid worden.

## Stap 4: de veiligheidspal, `--force-with-lease`

```bash
git push --force-with-lease origin main
```

```text
 ! [rejected]        main -> main (stale info)
```

*"Forceer, maar alleen als de remote nog staat waar ik hem het laatst zag."*
Dat is niet zo: Bob heeft intussen gepusht. Weer geweigerd. Mooi zo.

## Stap 5: wat `--force` doet 💥

```bash
git push --force origin main
git clone -q ~/lab/03/origin.git ~/lab/03/carol
git -C ~/lab/03/carol log --oneline
```

Carol, een nieuwe collega, cloned de gedeelde repository: **de commit van Bob is weg**.
Wie nu pullt, krijgt de versie van de geschiedenis van Alice.

## Stap 6: het herstel, en hoe het wel moet

Gelukkig heeft Bob zijn commit nog lokaal. Hij merget de herschreven remote in
zijn kopie, zodat beide ideeën erin zitten, en pusht dat:

```bash
cd ~/lab/03/bob
git log --oneline
git pull -q --no-rebase --no-edit origin main
git push -q origin main
git -C ~/lab/03/carol pull -q origin main
git -C ~/lab/03/carol log --oneline
```

Wat Alice in stap 3 had moeten doen: `git pull --rebase origin main`, en dan `git push`.

## 🤔 Vragen

1. Wat als Bob zijn lokale kopie al had verwijderd voordat hij het merkte?
2. Wanneer is `--force-with-lease` **wel** prima? (Tip: van wie is de branch?)
3. Welke branches moeten op het platform **beveiligd** worden, zodat niemand ze kan force-pushen?

🎉 Klaar! Draai de zelftest:

```shell
bash "$COURSES/courses/03-git/exercises/check.sh"
```
