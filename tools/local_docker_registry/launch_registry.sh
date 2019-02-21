#!/bin/bash
docker run -d \
  --restart=always \
  --name registry \
  -p 5000:5000 \
  registry:2
#  -v `pwd`/certs:/certs \
#  -e REGISTRY_HTTP_ADDR=0.0.0.0:443 \
#  -e REGISTRY_HTTP_TLS_CERTIFICATE=/certs/servercert.pem \
#  -e REGISTRY_HTTP_TLS_KEY=/certs/serverkey.pem \
#  -p 1443:443 \
