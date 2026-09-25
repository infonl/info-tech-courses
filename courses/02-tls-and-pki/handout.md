🇬🇧 English · 🇳🇱 [Nederlands](handout.nl.md)

# HTTPS & mTLS in practice

*Handout for course 02 · TLS & PKI in practice*

## What a client checks on every connection

1. **Chain**: the certificate leads to a root CA in the client's trust store
2. **Name**: the hostname is in the certificate's **SAN** list
3. **Dates**: today is between *not before* and *not after*
4. **Usage**: ServerAuth for servers, ClientAuth for client certificates
5. **Proof**: the other side signs the handshake with the matching private key

The padlock means *"private line to whoever controls this name"*. It says
nothing about whether that company is trustworthy.

## Going live with HTTPS: checklist

- [ ] The **SAN list** contains every name in use (`shop.example`, `www.shop.example`, API names…)
- [ ] The server sends the **full chain** (leaf + intermediates), not only its own certificate
- [ ] The key pair was generated **on or for the server** by its operator; the private key never travelled by e-mail
- [ ] **Renewal is automated** (ACME or the platform's managed certificates), with public TLS lifetimes going down to 200 → 100 → 47 days
- [ ] **Monitoring** checks the live endpoint and alerts a team weeks before expiry
- [ ] Only **TLS 1.2 and 1.3**; `http://` redirects to `https://`, with an HSTS header
- [ ] For a **private CA**: every client has received the **root CA certificate**, with its fingerprint checked out-of-band

## Onboarding a partner on mTLS: checklist

| # | Step | Who |
|---|------|-----|
| 1 | Agree the **CA model**: our private CA (partner sends a CSR) or the partner's own CA (partner sends its CA chain). Not a public CA: they stopped issuing ClientAuth certificates in June 2026 | both |
| 2 | Agree the **name** in the client certificate (e.g. `CN=acme-api-client`) that we will check | both |
| 3 | Partner **generates the key pair** on its own systems and keeps the private key | partner |
| 4 | Partner sends a **CSR** (model A) or its **CA certificate chain** (model B) | partner → us |
| 5 | **Verify** it really comes from the partner: compare the fingerprint by phone or via a known portal | us |
| 6 | Model A: we sign and return the **client certificate**. Model B: we add their CA as trust anchor | us |
| 7 | Configure the server: **trust the CA** *and* **check the name**; test and production separately | us |
| 8 | Test call from the partner; agree who **renews**, how early, and how a **compromised key** is reported | both |

## Error decoder

| You see | It means | Who fixes it |
|---------|----------|--------------|
| `unable to get local issuer certificate` · Java: `PKIX path building failed` · Python: `CERTIFICATE_VERIFY_FAILED` | Missing intermediate, or a private CA the client doesn't have | Server: send the full chain. Client: add the private root |
| `no alternative certificate subject name matches` · browser: `ERR_CERT_COMMON_NAME_INVALID` | The name isn't in the SAN list | Server owner: new certificate with the right names |
| `certificate has expired` · browser: `ERR_CERT_DATE_INVALID` | Expired (or the client's clock is wrong) | Certificate owner: renew, then automate |
| `self-signed certificate` | Certificate not issued by a CA the client trusts | Use a proper CA, or install that root knowingly |
| `alert certificate required` | mTLS: the client sent no certificate | Client: configure certificate + key |
| `alert unknown ca` / `bad certificate` | mTLS: client certificate from a CA the server doesn't trust | Agree on the CA; server adds the right trust anchor |
| `unsupported protocol` / `handshake failure` | No common TLS version or cipher | The side still on old TLS upgrades |

## Red flags 🚩

- `curl -k`, `--insecure`, `verify=False`, `NODE_TLS_REJECT_UNAUTHORIZED=0` in anything beyond a quick local test
- "It works in the browser, so the certificate is fine."
- "We pinned your certificate", with no rotation plan
- "Nobody knows who renews that certificate."
- "Just buy a client certificate from a public CA."
