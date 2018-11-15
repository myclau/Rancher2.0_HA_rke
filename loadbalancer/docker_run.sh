docker run -d --restart=unless-stopped --name=my-rancher-lb\
  -p 80:80 -p 443:443 \
  -v ./nginx/conf.d/rancher.conf:/etc/nginx/conf.d/rancher.conf \
  -v ./cert:/etc/nginx/certs \
  nginx:1.14

