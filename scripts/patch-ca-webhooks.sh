#!/bin/bash

SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
echo $SCRIPT_DIR

set -ex

cp -R manifests/* output/

# export CA_BUNDLE=$(kubectl config view --raw --flatten -o json | jq -r '.clusters[] | select(.name == "'$(kubectl config current-context)'") | .cluster."certificate-authority-data"')
export CA_BUNDLE=$(cat ${SCRIPT_DIR}/../certs/ca.crt | base64)

if command -v envsubst >/dev/null 2>&1; then
    envsubst < ${SCRIPT_DIR}/../manifests/mutatingwebhook.yaml > output/mutatingwebhook.yaml
    envsubst < ${SCRIPT_DIR}/../manifests/validatingwebhook.yaml > output/validatingwebhook.yaml
    envsubst < ${SCRIPT_DIR}/../manifests/ns.yaml > output/ns.yaml
else
    echo "ERROR: Please install envsubst"
fi
