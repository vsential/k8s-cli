FROM alpine:3.10.2

LABEL maintainer="James Bowling <jbowling@vmware.com>"

# Metadata
LABEL org.opencontainers.image.title="k8s-cli" \
      org.opencontainers.image.description="Provides kubectl client" \
      org.opencontainers.image.authors="James Bowling <jbowling@vmware.com>" \
      org.opencontainers.image.version="v1.15.3" \
      org.opencontainers.image.licenses="MIT License" \
      org.opencontainers.image.url="https://github.com/vsential/k8s-cli" \
      org.opencontainers.image.created=`date --iso-8601=ns`

ENV KUBE_LATEST_VERSION="v1.15.3"

RUN apk add --update ca-certificates \
 && apk add --update -t deps curl \
 && curl -L https://storage.googleapis.com/kubernetes-release/release/${KUBE_LATEST_VERSION}/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl \
 && chmod +x /usr/local/bin/kubectl \
 && apk del --purge deps \
 && rm /var/cache/apk/*

WORKDIR /root
ENTRYPOINT ["kubectl"]
CMD ["help"]