#!/bin/bash

SRV_CRT='server.crt'

openssl x509 -noout -text -in "$SRV_CRT"
