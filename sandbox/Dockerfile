# Student sandbox: the same tools and versions for everyone.
# Debian 13 "trixie" ships OpenSSL 3.5 (incl. post-quantum ML-KEM / ML-DSA).
FROM debian:trixie-slim

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y --no-install-recommends \
        openssl ca-certificates curl \
        python3 python3-cryptography \
        xxd file bsdextrautils \
        openssh-client netcat-openbsd iproute2 iputils-ping bind9-dnsutils tcpdump \
        bash-completion less nano git make jq \
    && rm -rf /var/lib/apt/lists/*

RUN useradd --create-home --shell /bin/bash student \
    && git config --system --add safe.directory '*'

USER student
WORKDIR /workspace

# Where the course repo is mounted; worksheets refer to files via $COURSES.
# The dev container overrides this with the actual workspace folder.
ENV COURSES=/workspace

CMD ["bash", "-l"]
