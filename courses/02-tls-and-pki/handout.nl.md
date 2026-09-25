🇬🇧 [English](handout.md) · 🇳🇱 Nederlands

# HTTPS & mTLS in de praktijk

*Hand-out bij cursus 02 · TLS & PKI in de praktijk*

## Wat een client bij elke verbinding controleert

1. **Keten**: het certificaat leidt naar een root CA in de trust store van de client
2. **Naam**: de hostnaam staat in de **SAN**-lijst van het certificaat
3. **Datums**: vandaag ligt tussen *not before* en *not after*
4. **Gebruik**: ServerAuth voor servers, ClientAuth voor clientcertificaten
5. **Bewijs**: de andere kant ondertekent de handshake met de bijbehorende private key

Het hangslot betekent *"een privélijn met wie deze naam in handen heeft"*. Het
zegt niets over de vraag of dat bedrijf te vertrouwen is.

## Live met HTTPS: checklist

- [ ] De **SAN-lijst** bevat elke naam die gebruikt wordt (`shop.example`, `www.shop.example`, API-namen…)
- [ ] De server stuurt de **volledige keten** mee (leaf + intermediates), niet alleen zijn eigen certificaat
- [ ] Het sleutelpaar is door de beheerder **op of voor de server** gemaakt; de private key is nooit per e-mail verstuurd
- [ ] **Vernieuwen gaat automatisch** (ACME of de managed certificates van het platform), want publieke TLS-certificaten gaan naar 200 → 100 → 47 dagen
- [ ] **Monitoring** controleert het live endpoint en waarschuwt een team weken voor de verloopdatum
- [ ] Alleen **TLS 1.2 en 1.3**; `http://` stuurt door naar `https://`, met een HSTS-header
- [ ] Bij een **private CA**: elke client heeft het **root-CA-certificaat** gekregen, en de fingerprint is via een ander kanaal gecontroleerd

## Een partner aansluiten op mTLS: checklist

| # | Stap | Wie |
|---|------|-----|
| 1 | Spreek het **CA-model** af: onze private CA (partner stuurt een CSR) of de eigen CA van de partner (partner stuurt zijn CA-keten). Geen publieke CA: die geven sinds juni 2026 geen ClientAuth-certificaten meer uit | beide |
| 2 | Spreek de **naam** in het clientcertificaat af (bijv. `CN=acme-api-client`) die wij gaan controleren | beide |
| 3 | Partner **maakt het sleutelpaar** op eigen systemen en houdt de private key zelf | partner |
| 4 | Partner stuurt een **CSR** (model A) of zijn **CA-certificaatketen** (model B) | partner → wij |
| 5 | **Controleer** dat het echt van de partner komt: vergelijk de fingerprint telefonisch of via een bekend portaal | wij |
| 6 | Model A: wij ondertekenen en sturen het **clientcertificaat** terug. Model B: wij voegen hun CA toe als trust anchor | wij |
| 7 | Stel de server in: **vertrouw de CA** *en* **controleer de naam**; test en productie apart | wij |
| 8 | Testaanroep door de partner; spreek af wie **vernieuwt**, hoe ruim van tevoren, en hoe een **gelekte key** gemeld wordt | beide |

## Foutmeldingen ontcijferd

| Je ziet | Het betekent | Wie lost het op |
|---------|--------------|-----------------|
| `unable to get local issuer certificate` · Java: `PKIX path building failed` · Python: `CERTIFICATE_VERIFY_FAILED` | Ontbrekende intermediate, of een private CA die de client niet heeft | Server: stuur de volledige keten mee. Client: voeg de private root toe |
| `no alternative certificate subject name matches` · browser: `ERR_CERT_COMMON_NAME_INVALID` | De naam staat niet in de SAN-lijst | Servereigenaar: nieuw certificaat met de juiste namen |
| `certificate has expired` · browser: `ERR_CERT_DATE_INVALID` | Verlopen (of de klok van de client staat verkeerd) | Eigenaar van het certificaat: vernieuwen, en daarna automatiseren |
| `self-signed certificate` | Certificaat is niet uitgegeven door een CA die de client vertrouwt | Gebruik een echte CA, of installeer die root bewust |
| `alert certificate required` | mTLS: de client stuurde geen certificaat | Client: certificaat + key instellen |
| `alert unknown ca` / `bad certificate` | mTLS: clientcertificaat van een CA die de server niet vertrouwt | Spreek de CA af; de server voegt de juiste trust anchor toe |
| `unsupported protocol` / `handshake failure` | Geen gemeenschappelijke TLS-versie of cipher | De kant die nog op oude TLS zit, moet upgraden |

## Rode vlaggen 🚩

- `curl -k`, `--insecure`, `verify=False`, `NODE_TLS_REJECT_UNAUTHORIZED=0` in iets anders dan een snelle lokale test
- "Het werkt in de browser, dus het certificaat is in orde."
- "We hebben jullie certificaat vastgepind", zonder plan voor vervanging
- "Niemand weet wie dat certificaat vernieuwt."
- "Koop gewoon een clientcertificaat bij een publieke CA."
