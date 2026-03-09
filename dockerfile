FROM alpine

RUN apk add --no-cache \
    bash \
    curl \
    git \
    jq \
    icu-libs \
    libstdc++ \
    ca-certificates \
    docker-cli

WORKDIR /azp

COPY start.sh .

RUN chmod +x start.sh

ENTRYPOINT ["./start.sh"]