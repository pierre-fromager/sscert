#!/bin/bash

# Config files
CSR_CONF='server.csr.cnf'
V3_CONF='v3.ext'

# Server stuffs
SRV_CSR='server.csr'
SRV_CRT='server.crt'
SRV_FINAL_CRT='trixie.local.crt'
SRV_KEY='server.key'
SRV_FINAL_KEY='trixie.local.key'
SRV_KEY_TYPE='rsa:2048'
SRV_DAYS=365

# CA stuffs
CA_KEY='ca.key'
CA_PEM='ca.pem'

# Generate key
openssl req -new -sha256 \
	-nodes -out "$SRV_CSR" \
	-newkey "$SRV_KEY_TYPE" \
	-keyout "$SRV_KEY" \
	-config <( cat "$CSR_CONF" )

# Generate cert
openssl x509 -req -in "$SRV_CSR" \
	-CA "$CA_PEM" \
	-CAkey "$CA_KEY" \
	-CAcreateserial \
	-out "$SRV_CRT"  \
	-days "$SRV_DAYS" \
	-sha256 \
	-extfile "$V3_CONF"

cp "$SRV_KEY" "$SRV_FINAL_KEY"
cp "$SRV_CRT" "$SRV_FINAL_CRT"
