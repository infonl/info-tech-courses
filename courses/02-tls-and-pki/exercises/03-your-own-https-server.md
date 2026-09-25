🇬🇧 English · 🇳🇱 [Nederlands](03-your-own-https-server.nl.md)

# 🛠 3 · Your own HTTPS server, and three ways to break it

⏱ 6 min · **Goal:** run `https://shop.example` in the sandbox, connect to it
properly, and then trigger the three classic support tickets.

`shop.example` isn't in DNS. `curl --resolve shop.example:8443:127.0.0.1`
means: *connect to 127.0.0.1, but check the certificate for `shop.example`*.

## Step 1: start the server

The server runs in the background and writes its output to `server.log`.

```bash
cd ~/lab/02
openssl s_server -accept 8443 -cert shop.crt -key shop.key -cert_chain intermediate.crt -www > server.log 2>&1 &
SERVER_PID=$!
sleep 1
```

> 💡 `Address already in use`? An old server is still running: `pkill -f s_server`, then try again.

## Step 2: connect like a client that trusts our root

```bash
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt https://shop.example:8443/ -o page.html
head -c 300 page.html; echo
openssl s_client -connect 127.0.0.1:8443 -servername shop.example -CAfile root.crt -verify_hostname shop.example </dev/null 2>/dev/null \
    | grep -E "^ *[0-9]+ s:|^ *i:|Protocol|Verify return code"
```

The test page lists the TLS details. `s_client` shows the chain the server
sends (leaf + intermediate), the TLS version, and `Verify return code: 0 (ok)`.

## Step 3: break it #1, a client that doesn't know our CA

```bash
curl -sS --resolve shop.example:8443:127.0.0.1 https://shop.example:8443/ -o /dev/null
```

```text
curl: (60) SSL certificate problem: unable to get local issuer certificate
```

This is every partner who hasn't installed your **private** root yet.

## Step 4: break it #2, the wrong name

```bash
curl -sS --cacert root.crt https://localhost:8443/ -o /dev/null
```

```text
curl: (60) SSL: no alternative certificate subject name matches target hostname 'localhost'
```

## Step 5: break it #3, the missing intermediate

Restart the server **without** `-cert_chain`, the most common server mistake:

```bash
kill $SERVER_PID; sleep 1
openssl s_server -accept 8443 -cert shop.crt -key shop.key -www > server.log 2>&1 &
SERVER_PID=$!
sleep 1
curl -sS --resolve shop.example:8443:127.0.0.1 --cacert root.crt https://shop.example:8443/ -o /dev/null
```

Same error as step 3, even though this client **does** trust our root. It can't
connect the server's certificate to it, because the link in the middle is missing.

## Step 6: clean up

```bash
kill $SERVER_PID
```

## 🤔 Questions

1. Steps 3 and 5 give **the same** error. How would you tell them apart when a
   partner reports it? (Hint: step 2's `s_client` line.)
2. For each break: who fixes it, the server owner or the client?
3. Why would a browser often *not* show error #3, while a Java or Python client does?

➡️ Next: [4 · Mutual TLS](04-mutual-tls.md)
