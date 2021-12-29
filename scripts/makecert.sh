#!/bin/bash

username=$1

if [ "$username" = "" ]; then
    echo "Username argument is required"
    exit 1
fi

pushd $PROJECT_HOME/dev-utils/certs
pwd

openssl genpkey -algorithm RSA -out ${username}-key.pem -pkeyopt rsa_keygen_bits:4096
openssl req -new -key ${username}-key.pem -out ${username}-csr.pem
openssl x509 -req -in ${username}-csr.pem -CA ca-crt.pem -CAkey ca-key.pem -CAcreateserial -out ${username}-crt.pem -days 3650

rm ${username}-csr.pem
rm ca-crt.srl

popd
