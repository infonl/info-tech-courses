🇬🇧 [English](handout.md) · 🇳🇱 Nederlands

# Sleutels & certificaten: wie heeft wat nodig?

*Hand-out bij cursus 01 · Crypto-basis*

## De gouden regel

> **De private key blijft thuis. De public key reist.**
> Wie jouw private key heeft, *is jou* voor een computer.

| Taak van crypto | Vraag | Gedaan met |
|-----------------|-------|------------|
| 🔒 Vertrouwelijkheid | Kan iemand anders dit lezen? | Versleuteling (AES-GCM, ChaCha20-Poly1305) |
| 🧾 Integriteit | Heeft iemand dit veranderd? | Hashes, handtekeningen, AEAD |
| 🪪 Authenticiteit | Met wie praat ik echt? | Handtekeningen + certificaten |

**Versleutel** met de *public key van de ontvanger*. **Onderteken** met *je eigen private key*.
Een **certificaat** is een public key plus een naam, ondertekend door een **CA**
(een notaris). Er zitten geen geheimen in.

## Mag dit bestand gedeeld worden?

| Bestand | Bevat | Delen met een andere partij? |
|---------|-------|:----------------------------:|
| `.csr` | public key + naam (certificaataanvraag) | 🟢 ja |
| `.crt`, `.cer` | certificaat | 🟢 ja |
| `ca.crt`, `chain.pem`, `ca-bundle.crt` | CA-certificaat/-certificaten | 🟢 ja |
| `.key` | private key | 🔴 **nooit** |
| `.p12`, `.pfx` | certificaat **+ private key** | 🔴 **nooit** |
| `.jks` | Java-keystore, vaak met private keys | 🔴 tenzij er alleen CA-certificaten in zitten (een *truststore*) |
| `.pem`, `.der` | kan van alles zijn | 👀 kijk erin |

**Open een `.pem` in een teksteditor.** Staat er `-----BEGIN CERTIFICATE-----`
of `-----BEGIN CERTIFICATE REQUEST-----`, dan mag je hem delen. Staat er
`-----BEGIN PRIVATE KEY-----` (of `RSA`/`EC`/`ENCRYPTED PRIVATE KEY`), dan **niet**.

## ServerAuth: "clients controleren dat ze met de echte server praten"

| Stap | Wie |
|------|-----|
| Sleutelpaar maken, private key bewaren | **Servereigenaar** |
| CSR naar de CA sturen; certificaat **+ intermediate(s)** installeren | **Servereigenaar** |
| Het **root**-certificaat van de CA vertrouwen | **Clients**. Gaat vanzelf bij een publieke CA; bij een **private CA** moet de servereigenaar ze **het root-CA-certificaat geven** |

## ClientAuth / mutual TLS: "de server controleert wie er belt"

| Stap | Wie |
|------|-----|
| Sleutelpaar maken, private key bewaren | **De client** (de partij die belt), op eigen systemen |
| Afspreken welke CA het clientcertificaat uitgeeft | **Beide**. Sinds juni 2026 is dat een **private CA**, want publieke CA's geven geen ClientAuth-certificaten meer uit |
| CA-model A: *onze* CA. Client stuurt een **CSR**, wij ondertekenen en sturen het **certificaat** terug | Client → wij → client |
| CA-model B: *hun* CA. Client stuurt zijn **CA-certificaatketen** | Client → wij |
| De uitgevende CA-certificaten instellen als trust anchor; eventueel ook de naam of fingerprint van het certificaat controleren | **De server** (de partij die controleert) |

## Vragen voor een derde partij

1. Wie authenticeert wie: zijn wij de **server**, de **client**, of allebei?
2. Welke **CA** geeft de certificaten uit? Een publieke, die van ons, of die van hen?
3. Wat hebben jullie van ons nodig? (Verwacht antwoord: een **CSR**, een
   **certificaat** of een **CA-certificaat**. Nooit een private key.)
4. Welke **naam** (CN / SAN) komt er in het certificaat, zodat we die kunnen controleren?
5. Hoe lang is het **geldig**, wie vernieuwt het, en hoeveel tijd krijgen we vooraf?
6. Hoe laten we elkaar weten dat een key **gelekt** is (intrekken, revocation)?
7. Aparte certificaten voor **test en productie**?

## Rode vlaggen 🚩

- "Stuur ons de private key / de .pfx en het wachtwoord."
- "Wij maken je sleutelpaar wel en mailen het je."
- "Zet de certificaatcontrole voorlopig even uit."
- "Het is self-signed, klik gewoon op accepteren."
- "We gebruiken hetzelfde certificaat en dezelfde key voor al onze klanten."

## Voorbeeldreactie

> We sturen je graag ons **certificaat en de CA-keten**. De private key houden
> we zelf, zodat niemand anders zich als ons kan voordoen. Moeten jullie ons
> als client authenticeren? Laat dan weten welke **CA** jullie accepteren, dan
> sturen we een **CSR**.
