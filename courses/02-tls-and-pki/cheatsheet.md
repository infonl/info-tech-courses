🇬🇧 English · 🇳🇱 [Nederlands](cheatsheet.nl.md)

# Cheat sheet · 02 TLS & PKI in practice

## Look at a live HTTPS server

```shell
curl -v https://shop.example -o /dev/null                   # handshake, certificate, HTTP
openssl s_client -connect shop.example:443 -servername shop.example </dev/null
openssl s_client -connect shop.example:443 -servername shop.example -showcerts </dev/null   # full chain as sent
openssl s_client -connect shop.example:443 -servername shop.example </dev/null 2>/dev/null \
    | openssl x509 -noout -subject -issuer -dates -ext subjectAltName
```

## Test against a private CA, or a server that isn't in DNS yet

```shell
curl --cacert root.crt https://shop.example/
curl --resolve shop.example:443:10.0.0.5 https://shop.example/   # connect to that IP, but check the real name
openssl s_client -connect 10.0.0.5:443 -servername shop.example -CAfile root.crt -verify_hostname shop.example
```

## Build a small chain

```shell
# Root CA (self-signed)
openssl req -x509 -new -key root.key -subj "/CN=My Root CA" -days 3650 \
    -addext "basicConstraints=critical,CA:TRUE" -addext "keyUsage=critical,keyCertSign,cRLSign" -out root.crt

# Sign a CSR with extensions chosen by the CA (in an .ext file)
openssl x509 -req -in shop.csr -CA intermediate.crt -CAkey intermediate.key -days 90 -extfile shop.ext -out shop.crt

# Verify, with the intermediate supplied as "untrusted" helper
openssl verify -CAfile root.crt -untrusted intermediate.crt shop.crt
cat shop.crt intermediate.crt > fullchain.pem
```

## A test HTTPS server

```shell
openssl s_server -accept 8443 -cert shop.crt -key shop.key -cert_chain intermediate.crt -www
# mutual TLS: require a client certificate from clientca.crt, and refuse bad ones
openssl s_server -accept 8443 -cert shop.crt -key shop.key -cert_chain intermediate.crt \
    -Verify 1 -verify_return_error -CAfile clientca.crt -www
```

## Mutual TLS as a client

```shell
curl --cert client.crt --key client.key https://api.example/
openssl s_client -connect api.example:443 -cert client.crt -key client.key </dev/null
```

## Expiry

```shell
openssl x509 -in shop.crt -noout -enddate
openssl x509 -in shop.crt -noout -checkend 2592000        # exit code 1 if it expires within 30 days
```

## Formats

```shell
openssl pkcs12 -export -in shop.crt -inkey shop.key -certfile intermediate.crt -out shop.p12   # PEM → .p12/.pfx
openssl pkcs12 -in shop.p12 -nokeys -out certs.pem          # .p12 → certificates (PEM)
openssl pkcs12 -in shop.p12 -nocerts -noenc -out shop.key   # .p12 → private key (careful!)
keytool -list -keystore keystore.p12                        # Java keystore contents
keytool -importcert -alias partner-root -file root.crt -keystore truststore.p12   # add a root to a Java truststore
```

## Trust stores

```shell
awk '/BEGIN CERT/' /etc/ssl/certs/ca-certificates.crt | wc -l   # how many roots does this Linux trust?
export REQUESTS_CA_BUNDLE=/path/to/bundle.pem                    # Python requests
export NODE_EXTRA_CA_CERTS=/path/to/extra-roots.pem              # Node.js
```
