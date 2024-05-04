# syntax=docker/dockerfile:1
FROM --platform=$BUILDPLATFORM ubuntu:24.04 AS build

ARG TARGETPLATFORM
ARG BUILDPLATFORM
ARG VERSION="0.2.3"
ARG TARGET_MCU="esp32"

LABEL org.opencontainers.image.authors="yk-lab <yk-lab@users.noreply.github.com>" \
      org.opencontainers.image.url="https://github.com/yk-lab/docker-mkspiffs" \
      org.opencontainers.image.documentation="https://github.com/yk-lab/docker-mkspiffs" \
      org.opencontainers.image.source="https://github.com/yk-lab/docker-mkspiffs" \
      org.opencontainers.image.vendor="yk-lab" \
      org.opencontainers.image.title="mkspiffs ver. ${VERSION}" \
      org.opencontainers.image.description="mkspiffs for ${TARGET_MCU}, ver. ${VERSION}."

SHELL ["/bin/bash", "-euxo", "pipefail", "-c"]

RUN rm -f /etc/apt/apt.conf.d/docker-clean
RUN \
    --mount=type=cache,target=/var/lib/apt/lists,sharing=locked \
    --mount=type=cache,target=/var/cache/apt,sharing=locked \
    apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates=20240203 \
    wget=1.21.4-1ubuntu4

RUN wget --no-verbose --show-progress --progress=dot:mega https://github.com/igrr/mkspiffs/releases/download/${VERSION}/mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64.tar.gz \
    && wget --no-verbose --show-progress --progress=dot:mega https://github.com/igrr/mkspiffs/releases/download/${VERSION}/mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64.tar.gz.sha256.txt \
    && awk '{print $3 "  " $1}' mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64.tar.gz.sha256.txt | sha256sum -c \
    && tar -xvf mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64.tar.gz \
    && mv mkspiffs-${VERSION}-arduino-${TARGET_MCU}-linux64/mkspiffs /usr/bin \
    && chmod +x /usr/bin/mkspiffs


FROM gcr.io/distroless/cc-debian12:nonroot

COPY --from=build /usr/bin/mkspiffs /usr/bin/mkspiffs
