FROM ubuntu:24.04

LABEL maintainer="Your Name <your@email.com>"
LABEL description="Ubuntu Desktop with KasmVNC for Google Cloud Shell"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
    wget \
    curl \
    gnupg \
    lsb-release \
    sudo \
    supervisor \
    dbus-x11 \
    x11-apps \
    x11-utils \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y \
    xfce4 \
    xfce4-goodies \
    xfce4-terminal \
    thunar \
    firefox \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO- https://github.com/kasmtech/KasmVNC/releases/download/v1.4.1/kasmvncserver_1.4.1_ubuntu24.04_amd64.deb -O /tmp/kasmvncserver.deb \
    && apt-get update \
    && apt-get install -y /tmp/kasmvncserver.deb \
    && rm -rf /tmp/kasmvncserver.deb \
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

ENV VNC_PORT=6901
ENV VNC_PASSWORD=ubuntu
ENV VNC_RESOLUTION=1280x720

EXPOSE 6901

VOLUME ["/home/ubuntu", "/shared"]

HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:6901/ || exit 1

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
