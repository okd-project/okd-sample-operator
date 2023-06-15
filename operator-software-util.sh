#!/bin/bash

GOLANG_VERSION=1.20.5
GOLANG_DOWNLOAD_URL=https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz
GOLANG_DOWNLOAD_SHA256=d7ec48cde0d3d2be2c69203bc3e0a44de8660b9c09a6e85c4732a3f7dc442612

OPERATOR_SDK_VERSION=v1.29.0
OPERATOR_SDK_BIN=/usr/bin/operator-sdk
KUSTOMIZE_VERSION=v5.0.3
OPM_VERSION=v1.28.0
OPM_BIN=/usr/bin/opm
OS=linux
ARCH=amd64
GOLANGCI_LINT_VERSION=v1.53.2

curl -fsSLo ${OPERATOR_SDK_BIN} "https://github.com/operator-framework/operator-sdk/releases/download/${OPERATOR_SDK_VERSION}/operator-sdk_${OS}_${ARCH}" \
    && chmod 0755 $OPERATOR_SDK_BIN

curl -fsSLo kustomize.tar.gz "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize/${KUSTOMIZE_VERSION}/kustomize_${KUSTOMIZE_VERSION}_${OS}_${ARCH}.tar.gz"  \
    && tar -C /usr/bin -xzf kustomize.tar.gz \
    && rm kustomize.tar.gz

curl -fsSLo ${OPM_BIN} "https://github.com/operator-framework/operator-registry/releases/download/${OPM_VERSION}/${OS}-${ARCH}-opm" \
    && chmod 0755 ${OPM_BIN}

curl -fsSL "$GOLANG_DOWNLOAD_URL" -o golang.tar.gz \
    && echo "$GOLANG_DOWNLOAD_SHA256  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz

curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s ${GOLANGCI_LINT_VERSION}
