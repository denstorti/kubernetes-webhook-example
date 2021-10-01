#!/bin/bash

set -e

mkdir -p ${CERTS_DIR}

openssl genrsa -out ${CERTS_DIR}/ca.key 2048
openssl req -new -x509 -days 365 -key ${CERTS_DIR}/ca.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=Acme Root CA" -out ${CERTS_DIR}/ca.crt
openssl req -newkey rsa:2048 -nodes -keyout ${CERTS_DIR}/server.key -subj "/C=CN/ST=GD/L=SZ/O=Acme, Inc./CN=${SERVICE_DNS}" -out ${CERTS_DIR}/server.csr
openssl x509 -req -extfile <(printf "subjectAltName=DNS:${SERVICE_DNS}") -days 365 -in ${CERTS_DIR}/server.csr -CA ${CERTS_DIR}/ca.crt -CAkey ${CERTS_DIR}/ca.key -CAcreateserial -out ${CERTS_DIR}/server.crt

# create the secret with CA cert and server cert/key
kubectl create secret generic admission-webhook-example-certs\
        --from-file=key.pem=${CERTS_DIR}/server.key \
        --from-file=cert.pem=${CERTS_DIR}/server.crt \
        --dry-run -o yaml > output/secret.yaml