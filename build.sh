#!/bin/env bash
rm -rf enterprise_gateway

if ! [ -z $1 ]; then
    cp -r $1 enterprise_gateway/
    echo "Using enterprise_gateway/ that was passed in: $1"
else
    git clone --branch feature-javascript-kernel https://github.com/ricklamers/enterprise_gateway
fi

# download EG kernel files
VERSION=2.5.2
wget https://github.com/jupyter/enterprise_gateway/releases/download/v$VERSION/jupyter_enterprise_gateway_kernel_image_files-$VERSION.tar.gz --directory-prefix=enterprise_gateway/etc/docker/kernel-javascript

BUILD_CTX=enterprise_gateway/etc/docker/kernel-javascript/
# prepare build context
cp -r enterprise_gateway/etc/kernel-launchers/javascript/ $BUILD_CTX
cp enterprise_gateway/etc/kernel-launchers/bootstrap/bootstrap-kernel.sh $BUILD_CTX
cp .dockerignore $BUILD_CTX

# build
docker build \
    --label maintainer="Orchest B.V. https://www.orchest.io" \
    -t orchest/kernel-javascript:$VERSION \
    $BUILD_CTX