🇬🇧 [English](joining.md) · 🇳🇱 Nederlands

# Meedoen aan een cursus

Elke cursus duurt 30–50 minuten: een kort verhaal, dan opdrachten in één van
twee tracks, en tot slot een gezamenlijke nabespreking. Je kiest je track aan
het begin van de sessie.

| | 🗣 Uitlegger | 🛠 Bouwer |
|---|---|---|
| **Je bent…** | iemand die aan klanten, partners of collega's uitlegt *wat* er nodig is en *waarom* | iemand die het zelf inricht, bouwt of problemen oplost |
| **Opdrachten** | scenariokaarten, in tweetallen, op papier | commando's in een terminal |
| **Je hebt nodig** | niets, neem alleen een pen mee | een laptop met de sandbox (zie hieronder) |

Twijfel je? Kom als uitlegger. Je kunt de opdrachten van de bouwers altijd op
het grote scherm meevolgen.

## 🗣 Uitleggers: niets voor te bereiden

De begeleider neemt geprinte scenariokaarten en een hand-out van één pagina
mee. Wil je vooruit lezen? Op elke cursuspagina staat een link naar allebei.

## 🛠 Bouwers: zet de sandbox klaar *vóór* de sessie

De **sandbox** is een kleine Linux-omgeving waarin alle tools al staan. Zo
heeft iedereen dezelfde versies en hoeft niemand iets op zijn eigen laptop te
installeren. Kies **één** van deze opties. Trek er 10 minuten voor uit; de
eerste keer opstarten duurt een paar minuten omdat er van alles gedownload wordt.

### Optie A · In je browser (GitHub Codespaces)

Het makkelijkst: je hoeft niets te installeren. Je hebt een GitHub-account
nodig met toegang tot de cursus-repository.

1. Open de cursus-repository op GitHub (de link staat in je uitnodiging).
2. Klik op **Code → Codespaces → Create codespace on main**.
3. Wacht tot VS Code in je browser opent, met onderin een terminal.

Verwijder de codespace na de cursus (**Code → Codespaces → ⋯ → Delete**), zodat
hij je gratis uren niet opmaakt.

### Optie B · VS Code + Docker Desktop

Werkt ook offline als het eenmaal staat.

1. Installeer [Docker Desktop](https://www.docker.com/products/docker-desktop/),
   [VS Code](https://code.visualstudio.com/) en de VS Code-extensie
   **Dev Containers**.
2. Clone de cursus-repository. Op Windows clone je hem **in WSL** (bijvoorbeeld
   in `~/projects`) en open je hem van daaruit met `code .`.
3. VS Code vraagt of je wilt **Reopen in Container**. Klik daarop, of kies
   *Dev Containers: Reopen in Container* in het command palette (`F1`).
4. Open een terminal (**Terminal → New Terminal**). De prompt toont `student@…`.

### Optie C · Alleen Docker, zonder VS Code

Vanuit de gecloonde repository:

```shell
docker build -t itc-sandbox sandbox
docker run --rm -it -v "$PWD":/workspace itc-sandbox
```

In Windows PowerShell gebruik je `${PWD}` in plaats van `"$PWD"`.

### Optie D · Je eigen Linux- of WSL-shell

Alleen als je daar handig mee bent. Je hebt OpenSSL 3, Python met
`cryptography`, `xxd` en `file` nodig (op Debian of Ubuntu:
`sudo apt install openssl python3-cryptography xxd file`). Daarna, in de repository:

```shell
export COURSES=$(pwd)
```

De `openssl` die standaard op macOS staat is LibreSSL en werkt anders: kies dan optie A, B of C.

## ✅ Ben ik er klaar voor?

Draai in de terminal van de sandbox:

```shell
bash "$COURSES/tools/ready.sh"
```

```text
Checking your course environment…
  ✅ OpenSSL 3.5.7 9 Jun 2026 (Library: OpenSSL 3.5.7 9 Jun 2026)
  ✅ Python with the cryptography library
  ✅ xxd
  ✅ file
  ✅ COURSES points to the course files (/workspace)

🎉 You're ready. See you at the course!
```

Bij elke ❌ staat een tip (in het Engels, net als de tools zelf). Niet op tijd
gelukt? Kom toch: werk samen met iemand, of volg mee op het grote scherm.

## Tijdens de sessie

- Open de **cursuspagina** (bijvoorbeeld `courses/01-crypto-basics/README.nl.md`).
  Die linkt naar de opdrachten, in de volgorde waarin je ze nodig hebt.
- Alles wat je maakt komt in `~/lab/<cursusnummer>`, nooit in de repository.
  Het is allemaal wegwerpmateriaal.
- Elke cursus heeft een zelfcontrole die laat zien wat je al gedaan hebt en wat
  er nog openstaat. Het commando staat op de cursuspagina.

## Als iets niet werkt

| Probleem | Probeer dit |
|----------|-------------|
| Geen **Codespaces**-optie onder de Code-knop | Codespaces staat misschien niet aan voor je account of organisatie. Kies optie B of C. |
| `docker: command not found` in WSL | Docker Desktop → *Settings → Resources → WSL integration* → zet je distro aan en open een nieuwe terminal. |
| `permission denied … docker.sock` | Je gebruiker zit nog niet in de groep `docker`: `sudo usermod -aG docker $USER`, sluit daarna VS Code of WSL af en start opnieuw (`wsl --shutdown`). |
| De sandbox bouwen mislukt tijdens het downloaden | Probeer een ander netwerk. Bedrijfs-VPN's en proxy's blokkeren soms Docker-downloads. |
| De dev container start, maar de terminal toont `root@…` of er is geen `$COURSES` | Bouw opnieuw: *Dev Containers: Rebuild Container* in het command palette. |
| Kom je er niet uit? | Laat het de begeleider vóór de sessie weten, of kom gewoon: je kunt samenwerken. |
