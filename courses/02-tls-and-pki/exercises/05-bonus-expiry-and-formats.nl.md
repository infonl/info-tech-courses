🇬🇧 [English](05-bonus-expiry-and-formats.md) · 🇳🇱 Nederlands

# 🛠 5 · Bonus: verloopdatums en formaten

⏱ 4 min · **Doel:** de verloopdatum controleren zoals een monitoringscript dat
doet, en een certificaat opnieuw verpakken voor Windows of Java zonder de
gouden regel te breken.

## Stap 1: wanneer verloopt hij?

```bash
cd ~/lab/02
openssl x509 -in shop.crt -noout -enddate
openssl x509 -in shop.crt -noout -checkend $((30*86400)) && echo "fine for 30 more days"
openssl x509 -in shop.crt -noout -checkend $((100*86400)) || echo "expires within 100 days: renew!"
```

`-checkend` geeft exitcode 0 of 1, en daar werken monitoringscripts mee.

## Stap 2: een verlopen certificaat

We geven een certificaat uit dat alleen begin 2025 geldig was:

```bash
openssl x509 -req -in shop.csr -CA intermediate.crt -CAkey intermediate.key \
    -not_before 20250101000000Z -not_after 20250401000000Z -extfile shop.ext -out expired.crt
openssl verify -CAfile root.crt -untrusted intermediate.crt expired.crt
```

```text
error 10 at 0 depth lookup: certificate has expired
```

## Stap 3: verpak het voor Windows, IIS of Java

Een `.p12` / `.pfx` bevat het certificaat, de keten **en de private key**,
beschermd met een wachtwoord.

```bash
openssl pkcs12 -export -in shop.crt -inkey shop.key -certfile intermediate.crt \
    -out shop.p12 -passout pass:demo-only
openssl pkcs12 -in shop.p12 -info -nokeys -passin pass:demo-only 2>&1 | grep -E "subject|issuer"
```

## Stap 4: in een truststore zitten geen geheimen

Voor een Java-*client* die onze private root moet vertrouwen, heb je alleen het
root-certificaat nodig. Vergelijk wat erin zit:

```bash
openssl pkcs12 -export -nokeys -jdktrust anyExtendedKeyUsage -in root.crt -out truststore.p12 -passout pass:demo-only
openssl pkcs12 -in truststore.p12 -info -noout -passin pass:demo-only 2>&1 | grep -iE "bag|key"
openssl pkcs12 -in shop.p12 -info -noout -passin pass:demo-only 2>&1 | grep -iE "bag|key"
```

## 🤔 Vragen

1. Je monitoring draait `-checkend` op een bestand op een server. Waarom kunnen
   gebruikers toch een verlopen certificaat te zien krijgen?
2. Welke van `shop.p12` en `truststore.p12` mag je naar een partner sturen?
3. Een leverancier vraagt om "de .pfx van jullie certificaat" om een koppeling
   met jullie op te zetten. Wat hebben ze waarschijnlijk eigenlijk nodig?

🎉 Klaar! Draai de zelftest:

```shell
bash "$COURSES/courses/02-tls-and-pki/exercises/check.sh"
```
