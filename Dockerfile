FROM python:3.11-alpine3.19

# OCI labels
LABEL org.opencontainers.image.source="https://github.com/GlobalNOC/ansible-collection-builder"
LABEL org.opencontainers.image.description="Container for building ansible collections"

# install ansible-core
ARG ANSIBLE_CORE_VERSION=2.16.6
RUN python3 -m pip install ansible-core~=$ANSIBLE_CORE_VERSION

# install curl to download yq
RUN apk add curl

# Install yq
ARG YQ_VERSION=4.43.1
RUN curl https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 -Lo /usr/bin/yq \
    && chmod +x /usr/bin/yq

# copy entrypoint script
COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
