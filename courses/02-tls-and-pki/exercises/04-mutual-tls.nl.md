🇬🇧 [English](04-mutual-tls.md) · 🇳🇱 Nederlands

# 🛠 4 · Mutual TLS

⏱ 5 min · **Doel:** partner *Acme* aansluiten op mTLS (mutual TLS, wederzijdse
TLS: ook de client laat een certificaat zien) met **onze** private client-CA
(model A), en zien wat de server doet met goede, ontbrekende en verkeerde
clientcertificaten.

## Stap 1: onze client-CA

Een aparte CA alleen voor clientcertificaten van partners, zodat hij nooit
verward kan worden met de serverketen.

```bash
cd ~/lab/02
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out clientca.key
openssl req -x509 -new -key clientca.key -subj "/CN=Our Partner Client CA" -days 365 \
    -addext "basicConstraints=critical,CA:TRUE" -addext "keyUsage=critical,keyCertSign,cRLSign" \
    -out clientca.crt
```

## Stap 2: Acme maakt zijn key en stuurt een CSR

*Dit gebeurt aan de kant van Acme.* De private key verlaat Acme nooit.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out acme.key
openssl req -new -key acme.key -subj "/O=Acme BV/CN=acme-api-client" -out acme.csr
```

## Stap 3: wij ondertekenen, alleen voor ClientAuth

*Terug aan onze kant.* In het echt controleer je eerst of de CSR echt van Acme
komt, bijvoorbeeld door de fingerprint telefonisch te vergelijken.

```bash
openssl req -in acme.csr -noout -subject
printf 'basicConstraints=CA:FALSE\nkeyUsage=critical,digitalSignature\nextendedKeyUsage=clientAuth\n' > acme.ext
openssl x509 -req -in acme.csr -CA clientca.crt -CAkey clientca.key -days 90 -extfile acme.ext -out acme.crt
openssl verify -CAfile clientca.crt -purpose sslclient acme.crt
```

We sturen `acme.crt` terug naar Acme, en de CA van onze server (`root.crt`) als ze die nog niet hebben.

## Stap 4: een server die een clientcertificaat **eist**

`-Verify 1` vraagt om een clientcertificaat en eist er een. `-verify_return_error`
zorgt dat de server foute certificaten **weigert** in plaats van ze alleen te loggen.

```bash
openssl s_server -accept 8443 -cert shop.crt -key shop.key -cert_chain intermediate.crt \
    -Verify 1 -verify_return_error -CAfile clientca.crt -www > server.log 2>&1 &
SERVER_PID=$!
sleep 1
```

## Stap 5: drie bellers

Acme, met zijn certificaat:

```bash
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt \
    --cert acme.crt --key acme.key https://shop.example:8443/ -o mtls.html
grep -A3 "Client certificate" mtls.html
```

Iemand zonder certificaat:

```bash
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt https://shop.example:8443/ -o /dev/null
```

Mallory, met een zelfgemaakt certificaat voor dezelfde naam:

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out mallory.key
openssl req -x509 -new -key mallory.key -subj "/O=Acme BV/CN=acme-api-client" -days 30 -out mallory.crt
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt \
    --cert mallory.crt --key mallory.key https://shop.example:8443/ -o /dev/null
```

## Stap 6: opruimen

```bash
kill $SERVER_PID
```

## 🤔 Vragen

1. Zoek de twee fouten op in *Foutmeldingen ontcijferd* op de hand-out. Wie
   moet elk ervan oplossen?
2. Het certificaat van Mallory heeft precies dezelfde naam als dat van Acme.
   Waarom helpt dat haar niet?
3. Welke bestanden gingen er heen en weer tussen Acme en ons? Welk bestand nooit?
4. Probeer stap 4 **zonder** `-verify_return_error` en laat Mallory nog eens
   bellen (daarna `kill $SERVER_PID`). Wat gebeurt er? Wat leert je dat over
   het testen van de serverconfiguratie van een partner?

➡️ Bonus: [5 · Verloopdatums en formaten](05-bonus-expiry-and-formats.nl.md)
