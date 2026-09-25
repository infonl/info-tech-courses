# Glossary EN ↔ NL

**Rule of thumb:** translate what people *say*, keep in English what people
*see* in software, files, configs and e-mails with vendors. On first use in a
Dutch text, write the Dutch word with the English term in brackets, for example
*sleutelpaar (key pair)*. After that, use whichever word colleagues will
actually meet at work.

## Translate

| English | Nederlands |
|---------|------------|
| key pair | sleutelpaar |
| to encrypt / decrypt | versleutelen / ontsleutelen |
| encryption | versleuteling |
| to sign / signature | ondertekenen / (digitale) handtekening |
| to verify | controleren, verifiëren |
| fingerprint | vingerafdruk |
| certificate | certificaat |
| chain of trust | vertrouwensketen |
| tamper-evident | verzegeld: "je ziet het als ermee geknoeid is" |
| confidentiality / integrity / authenticity | vertrouwelijkheid / integriteit / authenticiteit (echtheid) |
| expiry | verloopdatum |
| to revoke | intrekken |
| third party | derde partij |
| trust | vertrouwen |
| padlock / wax seal / notary / passport | hangslot / lakzegel / notaris / paspoort |

## Git: translate the metaphors, keep the commands

| English | Nederlands |
|---------|------------|
| photo album / photo | fotoalbum / foto |
| sticky note | plakbriefje |
| "you are here" (HEAD) | "je bent hier" |
| fix forward | vooruit repareren (fix forward) |
| the golden rule | de gouden regel |

Keep in English: commit, branch, merge, rebase, squash, cherry-pick, tag, HEAD,
reflog, revert, reset, push, pull, fetch, clone, repository, pull request,
merge request, force-push, fast-forward, diff, blame, remote, feature flag.
Dutch verbs are fine where people use them: committen, mergen, pushen.

## Keep in English

These appear in tools, file names, configs, tickets and vendor documentation.
Translating them makes it harder to recognise them in real life.

| Term | Dutch explanation, first use only |
|------|-------------------------------|
| private key | de geheime sleutel die je nooit deelt |
| public key | de sleutel die je gerust mag delen |
| hash, SHA-256 | vingerafdruk-functie |
| CA, root CA, intermediate CA | certificaatautoriteit, "de notaris" |
| CSR (certificate signing request) | certificaataanvraag |
| trust store, CA bundle, trust anchor | lijst met CA's die je vertrouwt |
| ServerAuth, ClientAuth, EKU | waarvoor een certificaat gebruikt mag worden |
| mTLS (mutual TLS) | wederzijdse TLS: ook de client laat een certificaat zien |
| TLS, SSL, handshake | — |
| PEM, DER, PKCS#12, .pfx, .p12, JKS | bestandsformaten |
| AES-GCM, ChaCha20-Poly1305, RSA, ECDSA, Ed25519, (EC)DH | namen van algoritmes |
| AEAD | versleuteling met ingebouwde fraudecontrole |
| man-in-the-middle | iemand die ongemerkt tussen twee partijen in zit |
| forward secrecy | — |
