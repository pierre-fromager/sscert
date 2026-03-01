# sscert

Self-signed openssl certs for local lan devices

Because openssl processes change through various version, here you can find two usefull bash files to automate the self signed process generation.

Here we are dealing with openssl v3 and above versions.

One step is dedicated to the CA generation part and the other to the server cert based onto the previous CA.

Once done you should add the CA pem into your browser cert authoritative manager to let your own CA to trust the generated cert server.

Then no bothering SSL/TLS message will be displayed any more trying to reach your lan page through your favorite NGINX/APACHE server.

## Two steps certification

### CA generation

```bash
#!/bin/bash

CA_KEY='ca.key'
CA_PEM='ca.pem'

openssl genrsa -des3 -out "$CA_KEY" 2048

openssl req -x509 -new -nodes \
	-key "$CA_KEY" \
	-sha256 \
	-days 365 \
	-out "$CA_PEM"
```

### Server generation


```bash

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

```
