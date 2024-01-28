FROM lsiobase/ubuntu:jammy

# Pulling TARGET_ARCH from build arguments and setting ENV variable
ARG TARGETARCH
ENV ARCH_VAR=$TARGETARCH

# Add Supervisor
RUN apt-get update && apt-get install -y \
    supervisor \
    libssl3 \
    libssl-dev \
    unzip \
    build-essential \
    git

COPY root/ /

# Build from the source
RUN git clone --depth 1 https://github.com/philippe44/AirConnect.git \
    && cd AirConnect \
    && git submodule update --init --depth 1 \
    && cd airupnp && make && cd .. && chmod +x ./bin/airupnp-$ARCH_VAR-static && mv ./bin/airupnp-$ARCH_VAR-static /bin/airupnp-$ARCH_VAR \
    && cd aircast && make && cd .. && chmod +x ./bin/aircast-$ARCH_VAR-static && mv ./bin/aircast-$ARCH_VAR-static /bin/aircast-$ARCH_VAR
