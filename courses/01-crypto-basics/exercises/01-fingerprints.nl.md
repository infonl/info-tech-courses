🇬🇧 [English](01-fingerprints.md) · 🇳🇱 Nederlands

# 🛠 1 · Vingerafdrukken (hashes)

⏱ 3 min · **Doel:** zien dat een hash (vingerafdruk-functie) altijd een
vingerafdruk (fingerprint) van vaste lengte geeft, en dat een piepkleine
wijziging een compleet andere vingerafdruk oplevert.

## Stap 1: maak een lab-map

Alles wat je vandaag maakt, zet je hier neer. Niet in de repo.

```bash
mkdir -p ~/lab/01 && cd ~/lab/01
```

## Stap 2: neem de vingerafdruk van een schuldbekentenis

```bash
echo "I owe you 10 euro" > iou.txt
openssl dgst -sha256 iou.txt
sha256sum iou.txt
```

Twee tools, dezelfde vingerafdruk:

```text
SHA2-256(iou.txt)= f6815391bc6de475651235f636f768e65a60378f4fb44ec8af4617ffce8884cb
f6815391bc6de475651235f636f768e65a60378f4fb44ec8af4617ffce8884cb  iou.txt
```

## Stap 3: vervals hem

```bash
echo "I owe you 1000 euro" > iou-forged.txt
openssl dgst -sha256 iou.txt iou-forged.txt
```

Twee tekens extra, en de vingerafdruk is totaal anders.

## Stap 4: een groot bestand

```bash
head -c 5000000 /dev/urandom > big.bin
openssl dgst -sha256 big.bin
```

## 🤔 Vragen

1. Uit hoeveel hex-tekens bestaat een SHA-256-vingerafdruk? Hoeveel bits is dat?
2. Werd de vingerafdruk langer bij het bestand van 5 MB?
3. Kun je `I owe you 10 euro` terughalen uit de vingerafdruk?
4. Waar heb je zulke vingerafdrukken al eens eerder gezien?

➡️ Volgende: [2 · Eén gedeelde sleutel](02-one-shared-key.nl.md)
