FROM hypriot/image-builder:latest

RUN sed -i 's/stretch/bookworm/g' /etc/apt/sources.list && \
    sed -i 's/bookworm\/updates/bookworm-security/' /etc/apt/sources.list && \
    sed -i '/bookworm-updates/d' /etc/apt/sources.list && \
    apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    binfmt-support \
    qemu \
    qemu-user-static \
    --no-install-recommends && \
    rm -rf /var/lib/apt/lists/*

COPY builder/ /builder/

# build sd card image
CMD /builder/build.sh
