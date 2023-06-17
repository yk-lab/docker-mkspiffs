# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM ubuntu:22.04 AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION="0.2.3"
ARG TARGET_MCU="esp32"

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN rm -f /etc/apt/apt.conf.d/docker-clean
RUN \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates=20230311ubuntu0.22.04.1 \
    wget=1.21.2-2ubuntu1

RUN wget --no-verbose --show-progress --progress=dot:mega https://github.com/igrr/mkspiffs/releases/download/${VERSION}/mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64.tar.gz \
    && wget --no-verbose --show-progress --progress=dot:mega https://github.com/igrr/mkspiffs/releases/download/${VERSION}/mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64.tar.gz.sha256.txt \
    && awk '{print $3 "  " $1}' mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64.tar.gz.sha256.txt | sha256sum -c \
    && tar -xvf mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64.tar.gz \
    && mv mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64/mkspiffs /usr/bin \
    && chmod +x /usr/bin/mkspiffs


FROM gcr.io/distroless/cc-debian11:nonroot

COPY --from=build /usr/bin/mkspiffs /usr/bin/mkspiffs
