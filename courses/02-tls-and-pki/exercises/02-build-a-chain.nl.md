🇬🇧 [English](02-build-a-chain.md) · 🇳🇱 Nederlands

# 🛠 2 · Bouw een vertrouwensketen

⏱ 4 min · **Doel:** dezelfde vorm bouwen als een echte publieke keten, root →
intermediate → server, en zien dat **de CA bepaalt** wat er in een certificaat komt.

## Stap 1: de root CA

De root ondertekent zichzelf. In zijn certificaat staat *"ik ben een CA"*
(`CA:TRUE`) en *"ik mag certificaten ondertekenen"* (`keyCertSign`).

```bash
mkdir -p ~/lab/02 && cd ~/lab/02
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out root.key
openssl req -x509 -new -key root.key -subj "/CN=Demo Root CA" -days 3650 \
    -addext "basicConstraints=critical,CA:TRUE" \
    -addext "keyUsage=critical,keyCertSign,cRLSign" \
    -out root.crt
```

## Stap 2: de intermediate CA

In het echt ligt de root key offline in een kluis; het dagelijkse ondertekenen
doet een intermediate. `pathlen:0` betekent: *deze CA mag servers
ondertekenen, maar geen andere CA's*.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out intermediate.key
openssl req -new -key intermediate.key -subj "/CN=Demo Intermediate CA" -out intermediate.csr
printf 'basicConstraints=critical,CA:TRUE,pathlen:0\nkeyUsage=critical,keyCertSign,cRLSign\n' > intermediate.ext
openssl x509 -req -in intermediate.csr -CA root.crt -CAkey root.key -days 1825 \
    -extfile intermediate.ext -out intermediate.crt
```

## Stap 3: het servercertificaat

De winkel maakt zijn eigen key en stuurt een CSR (certificaataanvraag). De
**CA** bepaalt de extensies: welke namen (SAN), en dat het alleen voor
ServerAuth is.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out shop.key
openssl req -new -key shop.key -subj "/CN=shop.example" -out shop.csr
printf 'basicConstraints=CA:FALSE\nkeyUsage=critical,digitalSignature\nextendedKeyUsage=serverAuth\nsubjectAltName=DNS:shop.example,DNS:www.shop.example\n' > shop.ext
openssl x509 -req -in shop.csr -CA intermediate.crt -CAkey intermediate.key -days 90 \
    -extfile shop.ext -out shop.crt
openssl x509 -in shop.crt -noout -subject -issuer -dates -ext subjectAltName,extendedKeyUsage
```

## Stap 4: controleer de keten

Alleen de root wordt **vertrouwd**. De intermediate is een hulpmiddel dat de
server meestuurt (`-untrusted`: "gebruik hem om de keten te bouwen, maar
vertrouw hem niet op zichzelf").

```bash
openssl verify -CAfile root.crt shop.crt
openssl verify -CAfile root.crt -untrusted intermediate.crt shop.crt
```

De eerste faalt met `unable to get local issuer certificate`, de meest
voorkomende TLS-fout die er is. De tweede zegt `OK`.

## Stap 5: het bestand met de volledige keten

Dit hoort een webserver mee te sturen: zijn eigen certificaat **plus** de intermediate.

```bash
cat shop.crt intermediate.crt > fullchain.pem
grep -c "BEGIN CERTIFICATE" fullchain.pem
```

## 🤔 Vragen

1. Waarom faalt de eerste `verify`, terwijl alles netjes ondertekend is?
2. Welk bestand moet je het allerbeste bewaken? En welk op één na?
3. `shop.csr` vroeg alleen om een naam. Wie besliste over `www.shop.example` en
   over ServerAuth? Wat zegt dat over "we zetten het gewoon in de CSR"?
4. Waarom zit de root niet in `fullchain.pem`?

➡️ Volgende: [3 · Je eigen HTTPS-server](03-your-own-https-server.nl.md)
