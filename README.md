# sscert

Self-signed openssl certs for local lan devices

Because openssl processes change through various version, here you can find two usefull bash files to automate the self signed process generation.

One step is dedicated to the CA generation part and the other to the server cert based onto the previous CA.

Once done you should add the CA into your browser cert authoritative manager to let your own CA to trust the server.
