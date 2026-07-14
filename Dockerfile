FROM ubuntu:22.04

LABEL org.opencontainers.image.title="Ubuntu Desktop for Mobile (VNC + Browser)"
LABEL org.opencontainers.image.description="Ubuntu LXDE desktop with TigerVNC, optimized for mobile VNC clients and browser access"
LABEL org.opencontainers.image.source="https://github.com/MasudRana0q/Ubuntu"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    ca-certificates \
    gnupg \
    lsb-release \
    sudo \
    supervisor \
    dbus-x11 \
    x11-apps \
    x11-utils \
    tigervnc-standalone-server \
    tigervnc-xorg-extension \
    lxde \
    lxde-common \
    firefox \
    && rm -rf /var/lib/apt/lists/*

RUN useradd -m -s /bin/bash ubuntu \
    && echo "ubuntu:ubuntu" | chpasswd \
    && adduser ubuntu sudo

RUN mkdir -p /home/ubuntu/.vnc \
    && chown -R ubuntu:ubuntu /home/ubuntu/.vnc

RUN mkdir -p /home/ubuntu/Desktop \
    && chown -R ubuntu:ubuntu /home/ubuntu/Desktop

RUN mkdir -p /shared \
    && chown -R ubuntu:ubuntu /shared

COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY scripts/start-vnc.sh /usr/local/bin/start-vnc.sh
RUN chmod +x /usr/local/bin/start-vnc.sh

ENV VNC_PORT=5900
ENV VNC_PASSWORD=ubuntu
ENV VNC_RESOLUTION=1024x768
ENV VNC_DEPTH=24

EXPOSE 5900

VOLUME ["/home/ubuntu", "/shared"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep Xtigervnc || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
