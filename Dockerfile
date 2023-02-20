ARG DISTRO=alpine
ARG DISTRO_VARIANT=3.17

FROM docker.io/tiredofit/nginx:${DISTRO}-${DISTRO_VARIANT}
LABEL maintainer="Dave Conroy (github.com/tiredofit)"

ARG HEADSCALE_VERSION
ARG HEADSCALEUI_VERSION

ENV HEADSCALE_VERSION=v0.20.0 \
    HEADSCALEUI_VERSION=2023.01.30-beta-1 \
    HEADSCALE_REPO_URL=https://github.com/juanfont/headscale \
    HEADSCALEUI_REPO_URL=https://github.com/gurucomputing/headscale-ui \
    #NGINX_SITE_ENABLED="headscale-ui" \
    NGINX_ENABLE_CREATE_SAMPLE_HTML=FALSE \
    NGINX_WORKER_PROCESSES=1 \
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
                    git \
                    go \
                    make \
                    && \
    \
    package install .headscaleui-build-deps \
                    nodejs \
                    npm \
                    && \
    \
    clone_git_repo "${HEADSCALE_REPO_URL}" "${HEADSCALE_VERSION}" && \
    go build -ldflags="-w -X github.com/juanfont/headscale/cmd/headscale/cli.Version=${HEADSCALE_VERSION}" -a ./cmd/headscale/ && \
    strip headscale && \
    mv headscale /usr/bin && \
    mkdir -p /assets/headscale && \
    cp config-example.yaml /assets/headscale && \
    \
    clone_git_repo "${HEADSCALEUI_REPO_URL}" "${HEADSCALEUI_VERSION}" && \
    sed -i "s|insert-version|${HEADSCALEUI_VERSION}|g" ./src/routes/settings.html/+page.svelte && \
    npm install && \
    npm run build && \
    mkdir -p "${NGINX_WEBROOT}" && \
    cp -R build/* "${NGINX_WEBROOT}" && \
    \
    package remove \
                    .headscale-build-deps \
                    .headscaleui-build-deps \
                    && \
    package cleanup && \
    \
    rm -rf /root/.cache \
           /root/.gitconfig \
           /root/go \
           /usr/src/*

EXPOSE 2323

COPY install /

