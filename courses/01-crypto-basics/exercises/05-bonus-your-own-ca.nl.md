🇬🇧 [English](05-bonus-your-own-ca.md) · 🇳🇱 Nederlands

# 🛠 5 · Bonus: wees je eigen notaris (CA)

⏱ 5 min · **Doel:** een certificaat (certificate) volgen van CSR
(certificaataanvraag) tot ondertekend certificaat, en zien wie welk bestand
nodig heeft.

Er zijn twee rollen. De **winkel** (`shop.example`) heeft `ec.key`. De
**notaris** is een piepkleine private CA (certificaatautoriteit).

## Stap 1: de notaris opent zijn kantoor

De CA krijgt een eigen sleutelpaar (key pair) en een certificaat met de tekst
"ik ben de notaris", ondertekend door zichzelf. Daardoor is het een
**root**-certificaat.

```bash
cd ~/lab/01
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out ca.key
openssl req -x509 -new -key ca.key -subj "/CN=Demo Notary CA" -days 30 -out ca.crt
```

## Stap 2: de winkel vult het aanvraagformulier in (CSR)

De winkel gebruikt **zijn eigen** private key (de geheime sleutel die je nooit
deelt). Hij vraagt om een ServerAuth-certificaat (waarvoor het certificaat
gebruikt mag worden: als server).

```bash
openssl req -new -key ec.key -subj "/CN=shop.example" \
    -addext "subjectAltName=DNS:shop.example" \
    -addext "extendedKeyUsage=serverAuth" \
    -out shop.csr
openssl req -in shop.csr -noout -text | head -15
grep -c "PRIVATE KEY" shop.csr
```

De telling is `0`: er zit geen private key in de CSR, dus je kunt hem veilig
naar de CA mailen.

## Stap 3: de notaris controleert en zet zijn stempel

```bash
openssl x509 -req -in shop.csr -CA ca.crt -CAkey ca.key -days 7 \
    -copy_extensions copy -out shop.crt
openssl x509 -in shop.crt -noout -subject -issuer -dates -ext subjectAltName,extendedKeyUsage
openssl x509 -in shop.crt -noout -fingerprint -sha256
```

## Stap 4: een bezoeker controleert het paspoort

Een bezoeker die de notaris vertrouwt (en `ca.crt` heeft):

```bash
openssl verify -CAfile ca.crt shop.crt
```

Een bezoeker die nog nooit van deze notaris heeft gehoord:

```bash
openssl verify shop.crt
```

Iemand die het als **client**-certificaat (ClientAuth) probeert te gebruiken:

```bash
openssl verify -CAfile ca.crt -purpose sslclient shop.crt
```

## Stap 5: hoort het certificaat bij de sleutel?

```bash
openssl x509 -in shop.crt -noout -pubkey | openssl sha256
openssl pkey -in ec.key -pubout | openssl sha256
```

Dezelfde vingerafdruk, dus hetzelfde sleutelpaar.

## 🤔 Vragen

1. Welke bestanden stuurde de winkel naar de notaris, en welke kreeg hij terug?
2. Welk bestand heeft een bezoeker nodig om `shop.crt` te vertrouwen? Mag je dat
   zomaar uitdelen?
3. Welk bestand moet de notaris het allerbeste bewaken? Wat kan iemand ermee?
4. Waarom faalt de controle met `-purpose sslclient`? Wat heeft een partner
   nodig om mutual TLS (mTLS, wederzijdse TLS: ook de client laat een
   certificaat zien) met jouw server te gebruiken?
5. Browsers zouden `shop.crt` ook niet vertrouwen. Waarom niet, en wat is er
   nodig om dat wel voor elkaar te krijgen?

🎉 Klaar! Draai de zelftest:

```shell
bash "$COURSES/courses/01-crypto-basics/exercises/check.sh"
```
