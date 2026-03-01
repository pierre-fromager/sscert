#!/bin/bash

CA_KEY='ca.key'
CA_PEM='ca.pem'

openssl genrsa -des3 -out "$CA_KEY" 2048

openssl req -x509 -new -nodes \
	-key "$CA_KEY" \
	-sha256 \
	-days 365 \
	-out "$CA_PEM"

