FROM ubuntu:22.04

LABEL org.opencontainers.image.title="Ubuntu Desktop for Mobile (VNC + noVNC Browser)"
LABEL org.opencontainers.image.description="Ubuntu LXDE desktop with TigerVNC and noVNC, optimized for mobile VNC clients and browser access"
LABEL org.opencontainers.image.source="https://github.com/MasudRana0q/Ubuntu"

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies first to take advantage of build cache
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
    novnc \
    websockify \
    && install -d -m 0755 /etc/apt/keyrings \
    && curl -fsSL https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor -o /etc/apt/keyrings/google-chrome.gpg \
    && chmod a+r /etc/apt/keyrings/google-chrome.gpg \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/google-chrome.gpg] https://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google-chrome.list \
    && apt-get update \
    && apt-get install -y google-chrome-stable \
    && rm -rf /var/lib/apt/lists/*

# Create user
RUN useradd -m -s /bin/bash ubuntu \
    && echo "ubuntu:ubuntu" | chpasswd \
    && adduser ubuntu sudo

# Create directories
RUN mkdir -p /home/ubuntu/.vnc \
    /home/ubuntu/Desktop \
    /shared \
    && chown -R ubuntu:ubuntu /home/ubuntu /shared

# Copy config and scripts
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY scripts/start-vnc.sh /usr/local/bin/start-vnc.sh
RUN chmod +x /usr/local/bin/start-vnc.sh

# Environment variables
ENV VNC_PORT=5900
ENV NO_VNC_PORT=6900
ENV VNC_PASSWORD=ubuntu
ENV VNC_RESOLUTION=1080x2340
ENV VNC_DEPTH=24

# Ports and volumes
EXPOSE 5900 6900
VOLUME ["/home/ubuntu", "/shared"]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep Xtigervnc || exit 1

# Command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
