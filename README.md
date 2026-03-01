# sscert

Self-signed openssl certs for local lan devices

Because openssl processes change through various version, here you can find two usefull bash files to automate the self signed process generation.

Here we are dealing with openssl v3 and above versions.

One step is dedicated to the CA generation part and the other to the server cert based onto the previous CA.

Once done you should add the CA pem into your browser cert authoritative manager to let your own CA to trust the generated cert server.

Then no bothering SSL/TLS message will be displayed any more trying to reach your lan page through your favorite NGINX/APACHE server.

## Two steps

### CA generation



### Server cert generation


