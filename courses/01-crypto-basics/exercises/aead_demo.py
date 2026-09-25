#!/usr/bin/env python3
"""Tamper with an encrypted payment order, with and without a tamper-evident seal.

The attacker never sees the key. They only flip bits in the encrypted bytes,
trying to turn "100" into "900".
"""
import os

from cryptography.exceptions import InvalidTag
from cryptography.hazmat.primitives import padding
from cryptography.hazmat.primitives.ciphers import Cipher, algorithms, modes
from cryptography.hazmat.primitives.ciphers.aead import AESGCM, ChaCha20Poly1305

MESSAGE = b"Pay Bob 100 euro. Regards, Alice"
POS = MESSAGE.index(b"1")  # where the amount starts


def flip(data: bytes) -> bytes:
    """What the attacker does: XOR one byte so that a '1' underneath turns into a '9'."""
    out = bytearray(data)
    out[POS] ^= ord("1") ^ ord("9")
    return bytes(out)


def report(name: str, plaintext: bytes) -> None:
    print(f"  {name:<20} 😱 accepted, recipient reads: {plaintext.decode()!r}")


def aes_cbc() -> None:
    key, iv = os.urandom(32), os.urandom(16)
    padder = padding.PKCS7(128).padder()
    enc = Cipher(algorithms.AES(key), modes.CBC(iv)).encryptor()
    ciphertext = enc.update(padder.update(MESSAGE) + padder.finalize()) + enc.finalize()

    # The IV travels next to the ciphertext, so the attacker can change it too.
    # In CBC, flipping a bit in the IV flips exactly that bit in the first block.
    dec = Cipher(algorithms.AES(key), modes.CBC(flip(iv))).decryptor()
    unpadder = padding.PKCS7(128).unpadder()
    plaintext = unpadder.update(dec.update(ciphertext) + dec.finalize()) + unpadder.finalize()
    report("AES-CBC (no seal)", plaintext)


def aead(name: str, cipher_class) -> None:
    key, nonce = os.urandom(32), os.urandom(12)
    ciphertext = cipher_class(key).encrypt(nonce, MESSAGE, None)
    try:
        report(name, cipher_class(key).decrypt(nonce, flip(ciphertext), None))
    except InvalidTag:
        print(f"  {name:<20} 🛡️  tampering detected, message refused")


if __name__ == "__main__":
    print(f"Alice encrypts: {MESSAGE.decode()!r}")
    print("The attacker flips bits in transit (without knowing the key)...\n")
    aes_cbc()
    aead("AES-256-GCM", AESGCM)
    aead("ChaCha20-Poly1305", ChaCha20Poly1305)
