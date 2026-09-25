🇬🇧 [English](03-key-pairs.md) · 🇳🇱 Nederlands

# 🛠 3 · Sleutelparen, PEM & DER

⏱ 5 min · **Doel:** sleutelparen (key pairs) maken, de publieke helft vinden, en
zien dat PEM en DER (bestandsformaten) hetzelfde zijn, alleen in een andere
verpakking.

## Stap 1: drie soorten sleutelpaar

```bash
cd ~/lab/01
openssl genpkey -algorithm RSA -pkeyopt rsa_keygen_bits:3072 -quiet -out rsa.key
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out ec.key
openssl genpkey -algorithm ED25519 -out ed25519.key
ls -l *.key
```

Let op de rechten `-rw-------`: OpenSSL zorgt dat alleen jij een private key (de
geheime sleutel die je nooit deelt) kunt lezen.

## Stap 2: kijk in een private key

```bash
head -3 ec.key
openssl pkey -in ec.key -noout -text
```

In het bestand staat `BEGIN PRIVATE KEY`. Zie je die regel ooit in een e-mail,
een ticket of een Git-repo? Dan is er iets misgegaan.

## Stap 3: haal de publieke helft eruit

```bash
for k in rsa ec ed25519; do openssl pkey -in $k.key -pubout -out $k.pub; done
cat ec.pub
```

Dit is het bestand dat je *wel* mag delen: `BEGIN PUBLIC KEY`. Dit is de public
key (de sleutel die je gerust mag delen).

## Stap 4: PEM of DER

PEM is tekst die je in een e-mail kunt plakken. DER is dezelfde data, maar
binair.

```bash
openssl pkey -pubin -in ec.pub -outform DER -out ec.pub.der
file ec.pub ec.pub.der
xxd ec.pub.der | head -3
```

PEM is gewoon DER, in base64, tussen een `BEGIN`- en een `END`-regel. Controleer
het maar:

```bash
sed '1d;$d' ec.pub | base64 -d | cmp - ec.pub.der && echo "identical bytes"
```

Bekijk de structuur zoals OpenSSL die ziet:

```bash
openssl asn1parse -in ec.pub
```

## Stap 5: vergelijk de groottes

```bash
for k in rsa ec ed25519; do
  printf '%-8s public key: %4s bytes\n' $k "$(openssl pkey -pubin -in $k.pub -outform DER | wc -c)"
done
```

## In het echt: bescherm de private key met een wachtwoordzin

Dit vraagt om een wachtwoordzin (passphrase), dus voer het zelf uit als je wilt:

```shell
openssl pkey -in ec.key -aes256 -out ec-protected.key
head -1 ec-protected.key
```

## 🤔 Vragen

1. Welke bestanden in `~/lab/01` kun je veilig naar een partner mailen?
2. De RSA- en EC-sleutels zijn ongeveer even veilig. Hoe groot is het verschil
   in grootte?
3. Wat zegt `file` over `ec.pub` en `ec.pub.der`? Klopt dat? Wat zegt dat over
   hoeveel je kunt vertrouwen op bestandsnamen en tools die gokken?
4. Kun je `ec.pub` maken uit `ec.key`? En `ec.key` uit `ec.pub`?

➡️ Volgende: [4 · Ondertekenen & controleren](04-sign-and-verify.nl.md)
