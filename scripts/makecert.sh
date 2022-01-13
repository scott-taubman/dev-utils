#!/bin/bash

username=$1

if [ "$username" = "" ]; then
    echo "Username argument is required"
    exit 1
fi

pushd $PROJECT_HOME/dev-utils/certs
pwd

openssl genpkey -algorithm RSA -out ${username}.key -pkeyopt rsa_keygen_bits:4096
openssl req -new -key ${username}.key -out ${username}.csr
openssl x509 -req -in ${username}.csr -CA ca-root.crt -CAkey ca-root.key -CAcreateserial -out ${username}.crt -days 3650
openssl pkcs12 -export -out ${username}.p12 -inkey ${username}.key -in ${username}.crt

rm ${username}.csr
rm ca-root.srl

popd
