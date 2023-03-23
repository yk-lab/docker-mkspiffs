# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM ubuntu:22.04 AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION="0.2.3"

RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates\
    wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

RUN set -e \
    && wget --no-verbose --show-progress --progress=dot:mega https://github.com/igrr/mkspiffs/releases/download/${VERSION}/mkspiffs-${VERSION}-arduino-esp32-linux64.tar.gz \
    && wget --no-verbose --show-progress --progress=dot:mega https://github.com/igrr/mkspiffs/releases/download/${VERSION}/mkspiffs-${VERSION}-arduino-esp32-linux64.tar.gz.sha256.txt \
    && awk '{print $3 "  " $1}' mkspiffs-${VERSION}-arduino-esp32-linux64.tar.gz.sha256.txt | sha256sum -c \
    && tar -xvf mkspiffs-${VERSION}-arduino-esp32-linux64.tar.gz \
    && mv mkspiffs-${VERSION}-arduino-esp32-linux64/mkspiffs /usr/bin \
    && chmod +x /usr/bin/mkspiffs


FROM gcr.io/distroless/cc-debian11:nonroot

COPY --from=build /usr/bin/mkspiffs /usr/bin/mkspiffs
