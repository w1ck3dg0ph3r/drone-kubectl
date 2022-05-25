FROM alpine:3.16

ARG KUBECTL_VERSION=stable

RUN apk add --no-cache curl gettext openssl && \
    if [ $KUBECTL_VERSION = "stable" ]; then KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt); fi && \
    if [ $KUBECTL_VERSION = "latest" ]; then KUBECTL_VERSION=$(curl -s https://storage.googleapis.com/kubernetes-release/release/latest.txt); fi && \
    echo Downloading kubectl $KUBECTL_VERSION... && \
    curl -#LO https://storage.googleapis.com/kubernetes-release/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl && \
    chmod +x kubectl && mkdir -p /opt/bin && mv kubectl /opt/bin/

COPY init.sh entrypoint.sh /
RUN ln -s /entrypoint.sh /usr/local/bin/kubectl
ENTRYPOINT ["/entrypoint.sh"]
CMD ["version"]
