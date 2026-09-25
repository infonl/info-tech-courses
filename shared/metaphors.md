# Metaphors we reuse

Use the same picture for the same idea in every course, so people can build on
what they already know. Always be ready to say where a metaphor breaks down:
that part is often the most useful lesson.

| Concept | Metaphor | Where it breaks down |
|---------|----------|----------------------|
| Hash | A **fingerprint** of a document | Real fingerprints can be forged with enough effort; a good hash can't be forged in practice. Two different documents *can* in theory share a hash (a collision), but for SHA-256 nobody has ever found one. |
| Symmetric key | A **house key**: the same key locks and unlocks | Copying a digital key leaves no trace; the owner never notices it's missing. |
| AEAD (AES-GCM, ChaCha20-Poly1305) | A **tamper-evident envelope**: sealed, and any change shows | The seal also covers data that is *not* secret (the "associated data"), such as headers. |
| Key pair | **Open padlocks** you hand out for free, plus the one key that opens them | You can't make a padlock from its key in real life, but you *can* derive the public key from the private key. The reverse is the impossible part. |
| Signature | A **wax seal** only you own | A wax seal looks the same on every letter; a signature is different for every document, because it's tied to that document's fingerprint. |
| Diffie–Hellman | **Mixing paint**: everyone sees the mixes, nobody can un-mix them | Paint mixing is only "hard" to undo because you can't separate paint; the maths is hard in a much more precise way. |
| Certificate | A **passport** for a public key | A passport has a photo; a certificate proves nothing until the holder *also* shows they have the matching private key. |
| Certificate Authority (CA) | A **notary** / the passport office | Your browser trusts ~150 public "passport offices" worldwide, and any one of them can issue for any name. |
| Trust store / CA bundle | The **list of passport offices you accept** | Every system has its own list: OS, browser, Java, Python, curl… |
| CSR | The **passport application form** | The form includes your public key, and you sign it with your private key to prove you have it. |
| Private key leaked | Someone **copied your house key and your wax seal** | Revoking a certificate is like reporting a passport stolen: not every border guard checks the list. |
| Man in the middle | Someone **swaps the padlock** in the post | — |
| Git commit | A **photo** of the whole project, with a note on the back pointing to the previous photo | Git doesn't store duplicate files twice; the "photo" reuses unchanged files |
| Git branch, tag | A **sticky note** on a photo (a branch moves along as you add photos, a tag stays put) | — |
| Git HEAD | The **"you are here"** arrow | — |
| Rebase, cherry-pick | **Re-taking** photos on top of another one: copies, not the originals | The originals still exist for a while (the reflog), which the metaphor doesn't show |
| Force-push | **Moving someone else's sticky note**, so their photos are no longer in the album | — |
