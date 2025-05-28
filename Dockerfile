FROM hypriot/image-builder:latest

RUN sed -i 's@deb.debian.org/debian@archive.debian.org/debian@g' /etc/apt/sources.list && \
    sed -i 's@security.debian.org/debian-security@archive.debian.org/debian-security@g' /etc/apt/sources.list && \
    sed -i 's@stretch-updates@@' /etc/apt/sources.list && \
    echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99nocheck && \
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
