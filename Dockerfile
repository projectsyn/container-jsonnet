FROM golang:1.25.1 AS builder

ARG JSONNET_VERSION=v0.21.0

RUN go install github.com/google/go-jsonnet/cmd/...@${JSONNET_VERSION}

FROM debian:stable-slim

LABEL org.opencontainers.image.source=https://github.com/projectsyn/container-jsonnet
LABEL org.opencontainers.image.description="Binaries for go-jsonnet"
LABEL org.opencontainers.image.licenses=MIT

RUN apt-get update && apt-get install -y ca-certificates tzdata && rm -r /var/lib/apt/lists /var/cache/apt/archives

COPY --from=builder /go/bin/jsonnet* /usr/local/bin/

ENTRYPOINT [ "jsonnet" ]
