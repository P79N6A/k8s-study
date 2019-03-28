#!/bin/bash

set -o errexit

# 当前目录
ROOT_PATH=$(cd `dirname $0`; pwd)


docker build --no-cache -t go-demo-stage:run . -f Dockerfile  \
--build-arg HTTP_PROXY=http://127.0.0.1:8080 \
--build-arg HTTPS_PROXY=http://127.0.0.1:8080


docker run -it -d -p 8082:8080 --name go-demo-stage go-demo-stage:run
