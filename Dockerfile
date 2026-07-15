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
    novnc \
    websockify \
    && rm -rf /var/lib/apt/lists/*

# Install the latest Firefox directly from Mozilla so the container is not
# tied to Ubuntu's snap packaging.
RUN ARCH="$(dpkg --print-architecture)" \
    && case "$ARCH" in \
        amd64) FIREFOX_ARCH="linux64" ;; \
        arm64) FIREFOX_ARCH="linux-aarch64" ;; \
        *) echo "Unsupported architecture: $ARCH" && exit 1 ;; \
    esac \
    && wget -O /tmp/firefox.tar.xz "https://download.mozilla.org/?product=firefox-latest-ssl&os=${FIREFOX_ARCH}&lang=en-US" \
    && tar -xJf /tmp/firefox.tar.xz -C /opt/ \
    && ln -sf /opt/firefox/firefox /usr/local/bin/firefox \
    && install -D /opt/firefox/browser/chrome/icons/default/default128.png /usr/share/pixmaps/firefox.png \
    && printf '%s\n' \
        '[Desktop Entry]' \
        'Version=1.0' \
        'Name=Firefox' \
        'Comment=Browse the Web' \
        'Exec=/usr/local/bin/firefox %u' \
        'Icon=firefox' \
        'Terminal=false' \
        'Type=Application' \
        'Categories=Network;WebBrowser;' \
        'StartupNotify=true' \
        > /usr/share/applications/firefox.desktop \
    && rm -f /tmp/firefox.tar.xz

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
ENV VNC_RESOLUTION=1024x960
ENV VNC_DEPTH=24

# Ports and volumes
EXPOSE 5900 6900
VOLUME ["/home/ubuntu", "/shared"]

# Healthcheck
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=3 \
    CMD pgrep Xtigervnc || exit 1

# Command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
