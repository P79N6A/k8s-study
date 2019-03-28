#!/bin/bash

set -o errexit

# 当前目录
ROOT_PATH=$(cd `dirname $0`; pwd)

echo "=========================Build go-demo-step1:build images===================================";


docker build --no-cache -t go-demo-step1:build . -f Dockerfile.step1 \
--build-arg HTTP_PROXY=http://127.0.0.1:8080  \
--build-arg HTTPS_PROXY=http://127.0.0.1:8080 

docker create --name step1 go-demo-step1:build

docker cp step1:/go/app/godemo ./godemo

docker rm -f step1

echo "=========================Building go-demo-step2:run images==================================";

docker build --no-cache -t go-demo-step2:run . -f Dockerfile.step2  \
--build-arg HTTP_PROXY=http://127.0.0.1:8080  \
--build-arg HTTPS_PROXY=http://127.0.0.1:8080 

rm ./godemo

docker rmi go-demo-step1:build


docker run -it -d -p 8081:8080 --name go-demo-old go-demo-step2:run