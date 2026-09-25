🇬🇧 English · 🇳🇱 [Nederlands](01-https-in-the-wild.nl.md)

# 🛠 1 · HTTPS in the wild

⏱ 3 min · **Goal:** see which CAs your system trusts, and look at a real
website's chain. Steps 2 and 3 need internet; no internet? Skip to worksheet 2.

## Step 1: the trust store

```bash
mkdir -p ~/lab/02 && cd ~/lab/02
awk '/BEGIN CERT/' /etc/ssl/certs/ca-certificates.crt | wc -l
ls /etc/ssl/certs | grep -i -E "isrg|digicert" | head
openssl x509 -in /etc/ssl/certs/ISRG_Root_X1.pem -noout -subject -dates
```

That's how many root CAs this Linux trusts, and one of them in detail:
*ISRG Root X1* is the root behind Let's Encrypt.

## Step 2: a real handshake

```shell
curl -v https://www.example.com -o /dev/null 2>&1 | grep -E "SSL connection|subject:|issuer:|expire date|SSL certificate verify"
```

## Step 3: the chain the server sends

```shell
openssl s_client -connect www.example.com:443 -servername www.example.com -showcerts </dev/null 2>/dev/null \
    | grep -E "^ *[0-9]+ s:|^ *i:"
```

Each line pair is one certificate: `s:` is who it's for (subject), `i:` who
signed it (issuer). Follow the chain: each issuer is the subject of the next line.

Try another site you use at work, too.

## 🤔 Questions

1. Is the root CA among the certificates the server sends? Why (not)?
2. How long is the site's certificate valid in total? Compare that with the
   public maximums of 200, 100 and 47 days.
3. The same site on a company laptop behind a TLS-inspecting proxy: what would
   the issuer look like?

➡️ Next: [2 · Build a chain of trust](02-build-a-chain.md)
