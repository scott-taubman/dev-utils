# Development certificates

This directory contains a collection of certificates that can be used during
development. The certificates are:

- `ca-root.crt`: Root CA certificate
- `ca-root.key`: Root CA key (passphrase: **changeme**)

Certificates that were created for use with a specific application can be found
in the certs folder for that application (e.g. `beer-garden/certs`).

## Creating a new Certificate

**Note:** A helper script is available in `scripts/makecert.sh` to run these
commands for you. Just supply the username as a parameter.

First, create a new private key:

```
openssl genpkey -algorithm RSA -out someuser.key -pkeyopt rsa_keygen_bits:4096
```

Next, create a certificate signing request:

```
openssl req -new -key someuser.key -out someuser.csr
```

When the question prompts come up, the only field you really need to fill out in
a meaningful way is the Common Name. Choose something that will help you
identify the certificate easily.

Now, create a signed certificate. You can optionally create a file containing
any subject alternate names to assign:

```
# Without SANs
openssl x509 -req -in someuser.csr \
-CA ca-root.crt -CAkey ca-root.key -CAcreateserial \
-out someuser.crt -days 3650

# With SANs
echo "subjectAltName = DNS:altname1, DNS:123.4.56.7" > san.ext
openssl x509 -req -in someuser.csr \
-CA ca-root.crt -CAkey ca-root.key -CAcreateserial \
-out someuser.crt -days 3650 -extfile san.ext
```

Finally, create a p12 certificate for use in a browser:

```
openssl pkcs12 -export -out someuser.p12 -inkey someuser.key -in someuser.crt
```
