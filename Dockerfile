ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.18

FROM docker.io/tiredofit/${DISTRO}:${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG HEADSCALE_VERSION

ENV HEADSCALE_VERSION=v0.22.2 \
    HEADSCALE_REPO_URL=https://github.com/juanfont/headscale \
    IMAGE_NAME="tiredofit/headscale" \
    IMAGE_REPO_URL="https://github.com/tiredofit/headscale/"

RUN source assets/functions/00-container && \
    set -x && \
    addgroup -S -g 2323 headscale && \
    adduser -D -S -s /sbin/nologin \
            -h /dev/null \
            -G headscale \
            -g "headscale" \
            -u 2323 headscale \
            && \
    \
    package update && \
    package upgrade && \
    package install .headscale-build-deps \
                    binutils \
                    git \
                    go \
                    make \
                    && \
    \
    clone_git_repo "${HEADSCALE_REPO_URL}" "${HEADSCALE_VERSION}" && \
    go mod download && \
    CGO_ENABLED=0 GOOS=linux go build -tags ts2019 -ldflags="-s -w -X github.com/juanfont/headscale/cmd/headscale/cli.Version=${HEADSCALE_VERSION}" -a ./cmd/headscale/ && \
    strip headscale && \
    mv headscale /usr/bin && \
    mkdir -p /assets/headscale && \
    cp config-example.yaml /assets/headscale && \
    \
    package remove \
                    .headscale-build-deps \
                    && \
    package cleanup && \
    \
    rm -rf /root/.cache \
           /root/.gitconfig \
           /root/go \
           /usr/src/*

EXPOSE 8080

COPY install /
