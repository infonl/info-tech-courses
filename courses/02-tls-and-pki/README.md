# 02 · TLS & PKI in practice *(planned)*

Builds on [01 · Crypto basics](../01-crypto-basics/README.md).

## Outline

- **The TLS 1.3 handshake**, step by step: ECDHE key agreement, the certificate,
  and the server proving it holds the private key
- **Chains in the wild**: `openssl s_client -showcerts` against real sites,
  missing intermediates, trust stores (OS, browser, Java, Python, curl)
- **Hands-on mTLS**: private CA, `openssl s_server` / `s_client -cert`,
  `curl --cert --key --cacert`, and what the errors look like
- **Explainers' playbook**: onboarding a partner on mTLS end-to-end: which CA
  model, which files travel where, test vs production, renewal and revocation
- **Expiry & rotation**: lifetimes getting shorter (public TLS certificates
  go down to 47 days by 2029), ACME automation, monitoring
- **Formats in practice**: PKCS#12/.pfx and JKS: when and how to convert,
  and why the private key still stays home
- ClientAuth after June 2026: private and dedicated client-certificate CAs
