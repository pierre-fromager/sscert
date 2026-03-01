#!/bin/bash

CA_KEY='ca.key'
CA_PEM='ca.pem'
CA_DAYS=365
CA_KEY_SIZE=2048

openssl genrsa \
	-des3 \
	-out "$CA_KEY" \
	"$CA_KEY_SIZE"

openssl req -x509 \
	-new -nodes \
	-key "$CA_KEY" \
	-sha256 \
	-days "$CA_DAYS" \
	-out "$CA_PEM"

