# Beer Garden Development certificates

This directory contains a collection of certificates that can be used during
beer-garden development. The certificates are:

- `ca-key.pem`: Root CA key (passphrase: **changeme**)
- `ca-crt.pem`: Root CA certificate

## Creating a new Certificate

**Note:** A helper script is available in `scripts/makescript.sh` to run these
commands for you. Just supply the username as a parameter.

First, create a new private key:

```
openssl genpkey -algorithm RSA -out someuser-key.pem -pkeyopt rsa_keygen_bits:4096
```

Next, create a certificate signing request:

```
openssl req -new -key someuser-key.pem -out someuser-csr.pem
```

When the question prompts come up, the only field you really need to fill out in
a meaningful way is the Common Name. Choose something that will help you
identify the certificate easily.

Finally, Create a signed certificate:

```
openssl x509 -req -in someuser-csr.pem -CA ca-crt.pem -CAkey ca-key.pem -CAcreateserial -out someuser-crt.pem -days 3650
```
