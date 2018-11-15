#!/bin/bash
docker run -d \
  --restart=always \
  --name registry \
  -p 5000:5000 \
  registry:2
