🇬🇧 [English](03-your-own-https-server.md) · 🇳🇱 Nederlands

# 🛠 3 · Je eigen HTTPS-server, en drie manieren om hem stuk te maken

⏱ 6 min · **Doel:** `https://shop.example` draaien in de sandbox, er netjes
verbinding mee maken, en daarna de drie klassieke supporttickets veroorzaken.

`shop.example` staat niet in DNS. `curl --resolve shop.example:8443:127.0.0.1`
betekent: *maak verbinding met 127.0.0.1, maar controleer het certificaat voor
`shop.example`*.

## Stap 1: start de server

De server draait op de achtergrond en schrijft zijn uitvoer naar `server.log`.

```bash
cd ~/lab/02
openssl s_server -accept 8443 -cert shop.crt -key shop.key -cert_chain intermediate.crt -www > server.log 2>&1 &
SERVER_PID=$!
sleep 1
```

> 💡 `Address already in use`? Er draait nog een oude server: `pkill -f s_server`, en probeer het opnieuw.

## Stap 2: maak verbinding als een client die onze root vertrouwt

```bash
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt https://shop.example:8443/ -o page.html
head -c 300 page.html; echo
openssl s_client -connect 127.0.0.1:8443 -servername shop.example -CAfile root.crt -verify_hostname shop.example </dev/null 2>/dev/null \
    | grep -E "^ *[0-9]+ s:|^ *i:|Protocol|Verify return code"
```

De testpagina toont de TLS-details. `s_client` laat de keten zien die de server
meestuurt (leaf + intermediate), de TLS-versie, en `Verify return code: 0 (ok)`.

## Stap 3: stuk #1, een client die onze CA niet kent

```bash
curl -sS --resolve shop.example:8443:127.0.0.1 https://shop.example:8443/ -o /dev/null
```

```text
curl: (60) SSL certificate problem: unable to get local issuer certificate
```

Dit is elke partner die jouw **private** root nog niet heeft geïnstalleerd.

## Stap 4: stuk #2, de verkeerde naam

```bash
curl -sS --cacert root.crt https://localhost:8443/ -o /dev/null
```

```text
curl: (60) SSL: no alternative certificate subject name matches target hostname 'localhost'
```

## Stap 5: stuk #3, de ontbrekende intermediate

Start de server opnieuw, maar nu **zonder** `-cert_chain`, de meest gemaakte
fout aan de serverkant:

```bash
kill $SERVER_PID; sleep 1
openssl s_server -accept 8443 -cert shop.crt -key shop.key -www > server.log 2>&1 &
SERVER_PID=$!
sleep 1
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt https://shop.example:8443/ -o /dev/null
```

Dezelfde fout als in stap 3, terwijl deze client onze root **wel** vertrouwt.
Hij kan het certificaat van de server er niet aan koppelen, omdat de schakel in
het midden ontbreekt.

## Stap 6: opruimen

```bash
kill $SERVER_PID
```

## 🤔 Vragen

1. Stap 3 en 5 geven **dezelfde** fout. Hoe houd je ze uit elkaar als een
   partner hem meldt? (Tip: de `s_client`-regel uit stap 2.)
2. Wie lost elke fout op: de servereigenaar of de client?
3. Waarom laat een browser fout #3 vaak *niet* zien, terwijl een Java- of
   Python-client dat wel doet?

➡️ Volgende: [4 · Mutual TLS](04-mutual-tls.nl.md)
