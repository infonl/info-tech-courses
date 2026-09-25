🇬🇧 [English](01-https-in-the-wild.md) · 🇳🇱 Nederlands

# 🛠 1 · HTTPS in het wild

⏱ 3 min · **Doel:** zien welke CA's (certificaatautoriteiten, "de notarissen")
je systeem vertrouwt, en de keten van een echte website bekijken. Voor stap 2
en 3 heb je internet nodig; geen internet? Ga dan door naar opdracht 2.

## Stap 1: de trust store

```bash
mkdir -p ~/lab/02 && cd ~/lab/02
awk '/BEGIN CERT/' /etc/ssl/certs/ca-certificates.crt | wc -l
ls /etc/ssl/certs | grep -i -E "isrg|digicert" | head
openssl x509 -in /etc/ssl/certs/ISRG_Root_X1.pem -noout -subject -dates
```

Zoveel root CA's vertrouwt deze Linux, en één daarvan zie je in detail:
*ISRG Root X1* is de root achter Let's Encrypt.

## Stap 2: een echte handshake

```shell
curl -v https://www.example.com -o /dev/null 2>&1 | grep -E "SSL connection|subject:|issuer:|expire date|SSL certificate verify"
```

## Stap 3: de keten die de server meestuurt

```shell
openssl s_client -connect www.example.com:443 -servername www.example.com -showcerts </dev/null 2>/dev/null \
    | grep -E "^ *[0-9]+ s:|^ *i:"
```

Elk paar regels is één certificaat: `s:` is voor wie het is (subject), `i:` wie
het heeft ondertekend (issuer). Volg de keten: elke issuer is het subject van de
volgende regel.

Probeer ook eens een andere site die je op je werk gebruikt.

## 🤔 Vragen

1. Zit de root CA tussen de certificaten die de server meestuurt? Waarom (niet)?
2. Hoe lang is het certificaat van de site in totaal geldig? Vergelijk dat met
   de publieke maximums van 200, 100 en 47 dagen.
3. Dezelfde site op een bedrijfslaptop achter een proxy die TLS inspecteert:
   hoe zou de issuer er dan uitzien?

➡️ Volgende: [2 · Bouw een vertrouwensketen](02-build-a-chain.nl.md)
