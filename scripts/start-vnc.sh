#!/bin/bash

mkdir -p /home/ubuntu/.vnc

if [ ! -f /home/ubuntu/.vnc/passwd ]; then
    echo "$VNC_PASSWORD" | vncpasswd -f > /home/ubuntu/.vnc/passwd
    chmod 600 /home/ubuntu/.vnc/passwd
fi

if [ ! -f /home/ubuntu/.vnc/xstartup ]; then
    cat > /home/ubuntu/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec startlxde
EOF
    chmod +x /home/ubuntu/.vnc/xstartup
fi

chown -R ubuntu:ubuntu /home/ubuntu/.vnc

export DISPLAY=:1

exec vncserver :1 \
    -rfbport $VNC_PORT \
    -geometry $VNC_RESOLUTION \
    -depth $VNC_DEPTH \
    -localhost no
