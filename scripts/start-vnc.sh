#!/bin/bash

mkdir -p /home/ubuntu/.vnc
chown -R ubuntu:ubuntu /home/ubuntu/.vnc

if [ ! -f /home/ubuntu/.vnc/passwd ]; then
    echo "${VNC_PASSWORD}" | vncpasswd -f > /home/ubuntu/.vnc/passwd
    chmod 600 /home/ubuntu/.vnc/passwd
    chown ubuntu:ubuntu /home/ubuntu/.vnc/passwd
fi

if [ ! -f /home/ubuntu/.vnc/xstartup ]; then
    cat > /home/ubuntu/.vnc/xstartup << 'EOF'
#!/bin/bash
xrdb $HOME/.Xresources
startlxde &
EOF
    chmod +x /home/ubuntu/.vnc/xstartup
    chown ubuntu:ubuntu /home/ubuntu/.vnc/xstartup
fi

chown -R ubuntu:ubuntu /home/ubuntu/.vnc

export USER=ubuntu
export HOME=/home/ubuntu

exec vncserver :1 \
    -rfbport ${VNC_PORT} \
    -geometry ${VNC_RESOLUTION} \
    -depth ${VNC_DEPTH} \
    -localhost no \
    -SecurityTypes VncAuth
