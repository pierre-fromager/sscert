#!/bin/bash

rm -f *.key\
	*.srl \
	*.pem \
	*.crt \
	*.csr

echo 00 > ca.srl

