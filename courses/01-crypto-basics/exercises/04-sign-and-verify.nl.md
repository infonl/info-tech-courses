🇬🇧 [English](04-sign-and-verify.md) · 🇳🇱 Nederlands

# 🛠 4 · Ondertekenen & controleren

⏱ 4 min · **Doel:** ondertekenen (sign) met een private key (de geheime sleutel
die je nooit deelt), controleren (verify) met een public key (de sleutel die je
gerust mag delen), en ontdekken wat een digitale handtekening (signature) je
*niet* vertelt.

Jij bent Alice. `ec.key` is jouw private key; `ec.pub` is jouw public key, en
die heeft Bob al.

## Stap 1: onderteken een contract

```bash
cd ~/lab/01
echo "I, Alice, owe Bob 10 euro." > contract.txt
openssl dgst -sha256 -sign ec.key -out contract.sig contract.txt
xxd contract.sig | head -3
```

## Stap 2: Bob controleert

```bash
openssl dgst -sha256 -verify ec.pub -signature contract.sig contract.txt
```

```text
Verified OK
```

## Stap 3: Bob wordt hebberig

```bash
sed 's/10/1000/' contract.txt > forged.txt
openssl dgst -sha256 -verify ec.pub -signature contract.sig forged.txt
```

```text
Verification failure
```

## Stap 4: Mallory ondertekent haar eigen vervalsing

Mallory maakt haar eigen sleutelpaar (key pair) en ondertekent het vervalste
contract.

```bash
openssl genpkey -algorithm EC -pkeyopt ec_paramgen_curve:P-256 -out mallory.key
openssl pkey -in mallory.key -pubout -out mallory.pub
openssl dgst -sha256 -sign mallory.key -out forged.sig forged.txt
```

Gecontroleerd met de public key van **Alice**:

```bash
openssl dgst -sha256 -verify ec.pub -signature forged.sig forged.txt
```

Gecontroleerd met de public key die Mallory zo behulpzaam meestuurt, "van
Alice":

```bash
openssl dgst -sha256 -verify mallory.pub -signature forged.sig forged.txt
```

## Stap 5: de moderne manier, Ed25519

```bash
openssl pkeyutl -sign -rawin -inkey ed25519.key -in contract.txt -out contract.ed25519.sig
openssl pkeyutl -verify -rawin -pubin -inkey ed25519.pub -in contract.txt -sigfile contract.ed25519.sig
wc -c contract.sig contract.ed25519.sig
```

## 🤔 Vragen

1. Is `contract.txt` geheim nu het ondertekend is?
2. In stap 4 zegt de laatste controle `Verified OK`. Wat bewijst dat, en wat
   bewijst het niet?
3. Wat moet Bob dus weten over een public key voordat hij een handtekening
   vertrouwt? (Dat is Deel 3 van de presentatie: **certificaten**.)
4. Stel dat de IT-afdeling van Alice haar sleutelpaar had gemaakt en een kopie
   had gehouden. Kan Alice dan nog zeggen "alleen ik kan dit ondertekend hebben"?

➡️ Bonus: [5 · Wees je eigen notaris (CA)](05-bonus-your-own-ca.nl.md)
