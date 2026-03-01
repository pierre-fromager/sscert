# sscert

Self-signed openssl certs for local lan devices

Because openssl processes change through various versions, here you can find two usefull bash files to automate the self signed process generation.

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

### Use case

#### Nginx

A template to let manage your SSL/TLS virtual host in sites-available(enable)


```bash
server {
	listen 80;
	#listen [::]:80;
	server_name trixie.local;

	return 301 https://$server_name$request_uri;
}


server {	
	listen 443 ssl;
	#listen [::]:443 ssl;
	server_name trixie.local;
	http2 on;
	
	access_log  /var/log/nginx/trixie.local/access.log;
	error_log  /var/log/nginx/trixie.local/error.log;

	location / {
		try_files $uri $uri/ =404;
		# kill cache
	        add_header Last-Modified $date_gmt;
        	add_header Cache-Control 'no-store, no-cache';
	        if_modified_since off;
        	expires off;
	        etag off;
	}

	ssl_certificate /home/pierre/certs/trixie.local.crt;
	ssl_certificate_key /home/pierre/certs/trixie.local.key;
		
	# Modern SSL setup
	ssl_protocols TLSv1.2 TLSv1.3;
	ssl_ciphers 'ECDHE-ECDSA-AES128-GCM-SHA256:ECDHE-RSA-AES128-GCM-SHA256:ECDHE-ECDSA-AES256-GCM-SHA384:ECDHE-RSA-AES256-GCM-SHA384:ECDHE-ECDSA-CHACHA20-POLY1305:ECDHE-RSA-CHACHA20-POLY1305:DHE-RSA-AES128-GCM-SHA256:DHE-RSA-AES256-GCM-SHA384';
	ssl_prefer_server_ciphers on;
    
	# SSL optimization
	ssl_session_timeout 1d;
	ssl_session_cache shared:SSL:10m;
	ssl_session_tickets off;
    
	# HSTS (optional, but recommended)
	add_header Strict-Transport-Security "max-age=63072000" always;


	root /home/pierre/tmp/mav2026/src/;
	
	index index.html index.htm;
}

```


