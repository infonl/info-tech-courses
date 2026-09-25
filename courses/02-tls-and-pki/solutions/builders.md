# Facilitator answers · Builder worksheets (course 02)

## 1 · HTTPS in the wild

1. **No.** The client must already have the root in its trust store. A root
   sent by the server proves nothing, because anyone can make a self-signed
   root. Some servers send it anyway; clients ignore it.
2. Depends on the site. Most public certificates today are 90 days (Let's
   Encrypt) or up to 200 days (since March 2026). Older certificates may still
   show ~398 days.
3. The issuer would be the company's proxy CA (for example "Corp TLS Inspection
   CA") instead of the real public CA. The chain ends at a root that only
   company laptops trust.

## 2 · Build a chain of trust

1. The verifier only knows the root. Without the intermediate it can't connect
   `shop.crt` (signed by the intermediate) to the root: `unable to get local
   issuer certificate`.
2. `root.key` most of all: with it, anyone can make new intermediates. Then
   `intermediate.key`: it can issue certificates for **any** name. The server's
   `shop.key` is third, but it's the one on an internet-facing machine.
3. The **CA**, through `shop.ext`. A CA decides what to put in a certificate
   after its own checks; it should never blindly copy what a CSR asks for.
   Real CAs validate each name in the SAN.
4. Clients must have the root already. Sending it is useless extra bytes.

## 3 · Your own HTTPS server

1. Run `openssl s_client -showcerts` (or step 2's command) against the server
   and count the certificates it sends. Only `0 s:` → the intermediate is
   missing (server problem). Leaf + intermediate sent, but still failing →
   the client doesn't trust the root (client problem, or a private CA they
   haven't installed).
2. #1 unknown CA: the **client** (install the private root). #2 wrong name:
   the **server owner** (new certificate). #3 missing intermediate: the
   **server owner** (send the full chain).
3. Browsers fetch missing intermediates via the certificate's AIA URL, or
   reuse cached ones. Most libraries don't.

## 4 · Mutual TLS

1. `alert certificate required`: no client certificate, **the client** must
   configure one. `alert unknown ca`: a client certificate from a CA the server
   doesn't trust. Agree on the CA; Mallory simply isn't allowed in.
2. The server checks that a **trusted CA** signed the certificate, and that the
   client can **sign with the matching private key**. Mallory can copy the name,
   but she can't get our client CA to sign her key, and she doesn't have Acme's key.
3. Travelled: `acme.csr` (Acme → us), `acme.crt` (us → Acme), and `root.crt`
   if Acme needs to trust our server. Never travelled: `acme.key`, and of course
   our `clientca.key`.
4. Without `-verify_return_error`, `s_server` logs the verification error but
   lets Mallory in. Lesson: a server that *asks* for client certificates isn't
   necessarily *enforcing* them. Test a partner connection with a **wrong**
   certificate too, not only the right one. In nginx `ssl_verify_client on`
   enforces; `optional` doesn't.

## 5 · Bonus: expiry and formats

1. The live server may use a different certificate than the file you checked:
   an old copy, another node behind the load balancer, or a CDN in front.
   Always monitor the **endpoint** (`openssl s_client … | openssl x509 -checkend`).
2. `truststore.p12` (only the root certificate, no key). **Never** `shop.p12`:
   it contains our private key.
3. To connect **to** us they only need to trust us: our CA certificate or chain.
   If they must authenticate **themselves**, they generate their own key and we
   issue them a client certificate (worksheet 4).
