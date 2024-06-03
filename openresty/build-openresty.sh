#!/bin/bash
set -ex

OPENRESTY_TAG=1.25.3.1-3
OPENRESTY_FLAVOR=jammy
DOCKER_IMAGE=jblaisdell/openresty
OPENSSL_VERSION=1.1.1w
OPENTRACING_VERSION=0.35.0
DD_OPENTRACING_CPP_VERSION=v1.3.7
LUAROCKS_VERSION=3.11.0
STANDALONE_DATADOG_VERSION=v1.0.2
NGINX_VERSION_SHORT=1.25.2
OPENTRACING_NGINX_VERSION=${OPENRESTY_TAG%\.[0-9]*-[0-9]*} # Strip '.##-##' from end of OPENRESTY_TAG

echo "Building OpenResty..."
echo "distro=$OPENRESTY_FLAVOR"
echo "version=$BUILD_VERSION"
echo "openresty_version=$OPENRESTY_TAG"
echo "image=$DOCKER_IMAGE"

docker build https://github.com/openresty/docker-openresty.git#${OPENRESTY_TAG} \
-f ${OPENRESTY_FLAVOR}/Dockerfile \
-t ${DOCKER_IMAGE} \
-t ${DOCKER_IMAGE}:latest \
--platform linux/amd64 \
--build-arg RESTY_LUAROCKS_VERSION=${LUAROCKS_VERSION} \
--build-arg RESTY_IMAGE_BASE=ubuntu \
--build-arg RESTY_EVAL_POST_MAKE="cd /usr/local/openresty/nginx/modules \
    && wget -O - https://github.com/DataDog/dd-opentracing-cpp/releases/download/${DD_OPENTRACING_CPP_VERSION}/linux-amd64-libdd_opentracing_plugin.so.gz | gunzip -c > libdd_opentracing_plugin.so \
    && wget -O - https://github.com/opentracing-contrib/nginx-opentracing/releases/download/v${OPENTRACING_VERSION}/linux-amd64-nginx-${OPENTRACING_NGINX_VERSION}-ngx_http_module.so.tgz | tar zxf - \
    && wget -O - https://github.com/DataDog/nginx-datadog/releases/download/${STANDALONE_DATADOG_VERSION}/nginx_${NGINX_VERSION_SHORT}-ngx_http_datadog_module.so.tgz | tar zxf - \
    && ldconfig" \
--build-arg RESTY_ADD_PACKAGE_RUNDEPS=wget \
--build-arg RESTY_OPENSSL_VERSION=${OPENSSL_VERSION} \
--label openresty_tag=${OPENRESTY_TAG} \
--label openresty_flavor=${OPENRESTY_FLAVOR} \
--label openssl_version=${OPENSSL_VERSION} \
--label opentracing_version=${OPENTRACING_VERSION} \
--label datadog_version=${DD_OPENTRACING_CPP_VERSION}
