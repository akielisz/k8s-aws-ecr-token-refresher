FROM alpine:3.20.3

apk update && \
    apk add --no-cache \
    curl \
    ca-certificates \
    gnupg \
    aws-cli \
    bash && \
    KUBECTL_VERSION=$(curl -L -s https://dl.k8s.io/release/stable.txt | sed 's/^v//' | cut -d'.' -f1,2) && \
    curl -fsSLo /usr/local/bin/kubectl https://dl.k8s.io/release/v${KUBECTL_VERSION}.0/bin/linux/amd64/kubectl && \
    chmod +x /usr/local/bin/kubectl

ENV AWS_REGION=""
ENV AWS_ACCOUNT=""
ENV AWS_ACCESS_KEY_ID=""
ENV AWS_SECRET_ACCESS_KEY=""
ENV DOCKER_SECRET_NAME=""
ENV NAMESPACE_NAME="default"

COPY refresh-ecr-token.sh /usr/local/bin/refresh-ecr-token.sh
RUN chmod +x /usr/local/bin/refresh-ecr-token.sh

ENTRYPOINT ["/usr/local/bin/refresh-ecr-token.sh"]
