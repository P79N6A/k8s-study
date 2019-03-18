#!/usr/bin/env bash

read -p "Input https proxy address:" HTTPS_PROXY

echo "Your https proxy address:${HTTPS_PROXY}"

read -p "Input http proxy address:" HTTP_PROXY

echo "Your http proxy address:${HTTP_PROXY}"

export no_proxy="127.0.0.1,localhost"
export http_proxy="${HTTP_PROXY}"
export https_proxy="${HTTPS_PROXY}"
