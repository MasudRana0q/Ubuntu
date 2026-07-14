#!/bin/bash

mkdir -p /home/ubuntu/.vnc
chown -R ubuntu:ubuntu /home/ubuntu/.vnc

if [ ! -f /home/ubuntu/.vnc/passwd ]; then
    echo "${VNC_PASSWORD}" | vncpasswd -f > /home/ubuntu/.vnc/passwd
fi
chmod 600 /home/ubuntu/.vnc/passwd
chown ubuntu:ubuntu /home/ubuntu/.vnc/passwd

# Always rewrite xstartup so the desktop session uses the latest known-good command.
cat > /home/ubuntu/.vnc/xstartup << 'EOF'
#!/bin/bash
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
exec dbus-launch --exit-with-session startlxde
EOF
chmod +x /home/ubuntu/.vnc/xstartup
chown ubuntu:ubuntu /home/ubuntu/.vnc/xstartup

chown -R ubuntu:ubuntu /home/ubuntu/.vnc

export USER=ubuntu
export HOME=/home/ubuntu

# Clean up old VNC display locks before starting a fresh server.
rm -f /tmp/.X1-lock
rm -f /tmp/.X11-unix/X1
rm -f /home/ubuntu/.vnc/*.log
rm -f /home/ubuntu/.vnc/*.pid

exec vncserver -fg :1 \
    -rfbport ${VNC_PORT} \
    -rfbauth /home/ubuntu/.vnc/passwd \
    -geometry ${VNC_RESOLUTION} \
    -depth ${VNC_DEPTH} \
    -localhost no \
    -SecurityTypes VncAuth
