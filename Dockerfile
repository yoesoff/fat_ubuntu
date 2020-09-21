FROM ubuntu:20.10

# Set timezone
ENV TZ=Asia/Jakarta
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install Java https://github.com/AdoptOpenJDK/openjdk-docker/blob/master/11/jdk/ubuntu/Dockerfile.hotspot.nightly.full
ENV LANG='en_US.UTF-8' LANGUAGE='en_US:en' LC_ALL='en_US.UTF-8'

RUN apt-get update \
    && apt-get install -y --no-install-recommends tzdata curl ca-certificates fontconfig locales \
    && echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen \
    && locale-gen en_US.UTF-8 \
    && rm -rf /var/lib/apt/lists/*

ENV JAVA_VERSION jdk11u

RUN set -eux; \
    ARCH="$(dpkg --print-architecture)"; \
    case "${ARCH}" in \
       aarch64|arm64) \
         ESUM='c51c1d85bccdccaed41ef735e60d581e19e676ac4d2cd8df3e4dd8b1bb407616'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk11u-2020-08-04-06-22/OpenJDK11U-jdk_aarch64_linux_hotspot_2020-08-04-06-22.tar.gz'; \
         ;; \
       armhf|armv7l) \
         ESUM='21c17e0f9be18d83aba775e900345bf760c4c5c8333f17e74fba850cb96a1c2e'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk11u-2020-08-04-06-22/OpenJDK11U-jdk_arm_linux_hotspot_2020-08-04-06-22.tar.gz'; \
         ;; \
       ppc64el|ppc64le) \
         ESUM='4f4fa3a81a66da405c6d2c5b9af1f8cfd16dee06a0245065dbf030e727bb8509'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk11u-2020-08-04-06-22/OpenJDK11U-jdk_ppc64le_linux_hotspot_2020-08-04-06-22.tar.gz'; \
         ;; \
       s390x) \
         ESUM='ec7028a4d210e78952dd815d52c61c5bb3b2f84f028802505f30d63829162b7f'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk11u-2020-08-04-06-22/OpenJDK11U-jdk_s390x_linux_hotspot_2020-08-04-06-22.tar.gz'; \
         ;; \
       amd64|x86_64) \
         ESUM='aa9cc471822f404d8c00e6274efcac55886db57ec7c2fafd850f63615c4e119d'; \
         BINARY_URL='https://github.com/AdoptOpenJDK/openjdk11-binaries/releases/download/jdk11u-2020-08-04-06-22/OpenJDK11U-jdk_x64_linux_hotspot_2020-08-04-06-22.tar.gz'; \
         ;; \
       *) \
         echo "Unsupported arch: ${ARCH}"; \
         exit 1; \
         ;; \
    esac; \
    curl -LfsSo /tmp/openjdk.tar.gz ${BINARY_URL}; \
    echo "${ESUM} */tmp/openjdk.tar.gz" | sha256sum -c -; \
    mkdir -p /opt/java/openjdk; \
    cd /opt/java/openjdk; \
    tar -xf /tmp/openjdk.tar.gz --strip-components=1; \
    rm -rf /tmp/openjdk.tar.gz;

ENV JAVA_HOME=/opt/java/openjdk
ENV PATH="/opt/java/openjdk/bin:$PATH"


