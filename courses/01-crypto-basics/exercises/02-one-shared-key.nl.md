🇬🇧 [English](02-one-shared-key.md) · 🇳🇱 Nederlands

# 🛠 2 · Eén gedeelde sleutel (symmetrische versleuteling)

⏱ 4 min · **Doel:** versleutelen (encrypt) en ontsleutelen (decrypt) met één
gedeelde sleutel, en zien waarom een *verzegelde* (tamper-evident) versleuteling
(AEAD, versleuteling met ingebouwde fraudecontrole) belangrijk is: je ziet het
als ermee geknoeid is.

## Stap 1: op slot en weer open

```bash
cd ~/lab/01
echo "The safe code is 4-8-15-16" > secret.txt
openssl enc -aes-256-cbc -pbkdf2 -in secret.txt -out secret.enc -pass pass:correct-horse
xxd secret.enc
```

De uitvoer begint met `Salted__` en ziet er daarna uit als ruis. Maak het nu
open met het juiste wachtwoord, en daarna met een verkeerd wachtwoord:

```bash
openssl enc -d -aes-256-cbc -pbkdf2 -in secret.enc -pass pass:correct-horse
openssl enc -d -aes-256-cbc -pbkdf2 -in secret.enc -pass pass:wrong-horse
```

> 💡 Met `-pass pass:…` zet je het wachtwoord op de command line. Daar komt het
> in je shell history terecht. Voor een demo is dat prima. In het echt laat je
> het weg, dan vraagt OpenSSL zelf om het wachtwoord.

## Stap 2: knoei met een versleutelde betaling

Een aanvaller onderschept het versleutelde bericht `Pay Bob 100 euro` en flipt
een paar bits. Hij kent de sleutel **niet**.

```bash
python3 "$COURSES/courses/01-crypto-basics/exercises/aead_demo.py"
```

```text
  AES-CBC (no seal)    😱 accepted, recipient reads: 'Pay Bob 900 euro. Regards, Alice'
  AES-256-GCM          🛡️  tampering detected, message refused
  ChaCha20-Poly1305    🛡️  tampering detected, message refused
```

## Stap 3: snelheid

Hoe snel is elk slot? Elke regel duurt ongeveer een seconde.

```bash
openssl speed -seconds 1 -bytes 16384 -evp aes-256-gcm 2>/dev/null | tail -1
openssl speed -seconds 1 -bytes 16384 -evp chacha20-poly1305 2>/dev/null | tail -1
openssl speed -seconds 1 -bytes 16384 -evp des-ede3-cbc 2>/dev/null | tail -1
```

De getallen zijn in duizenden bytes per seconde.

## 🤔 Vragen

1. Het verkeerde wachtwoord gaf `bad decrypt`. Gaat ontsleutelen met een
   verkeerde sleutel *altijd* luidruchtig mis?
2. Hoe kon de aanvaller `100` in `900` veranderen zonder de sleutel?
3. TLS 1.3 staat alleen AEAD-versleuteling toe (GCM, ChaCha20-Poly1305). Waarom?
4. Hoeveel sneller is AES-GCM dan 3DES op deze machine?
5. Beide kanten hebben dezelfde sleutel nodig. Hoe krijg je die veilig bij de
   ander? (Dat is Deel 2 van de presentatie.)

➡️ Volgende: [3 · Sleutelparen, PEM & DER](03-key-pairs.nl.md)
