# Ubuntu Desktop for Mobile (VNC + noVNC Browser)

Production-ready Docker project for Ubuntu Desktop (LXDE) with TigerVNC and noVNC, optimized for **mobile VNC clients** (AVNC, RealVNC Viewer, RVNC) and Google Cloud Shell!

## Features
- 📱 **Optimized for Mobile**: Works great with VNC clients and browser
- 🖥️ Ubuntu 22.04 (compatible with older Docker versions)
- 🔒 TigerVNC (secure, widely supported)
- 🌐 noVNC (browser access)
- 📂 Shared folder + persistent storage
- 📄 Clean, simple scripts

## Requirements
- Docker

## Quick Start

### Step 1: Clone the Project
```bash
git clone https://github.com/MasudRana0q/Ubuntu.git
cd Ubuntu
```

### Step 2: Make Scripts Executable
```bash
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh web-tunnel.sh scripts/docker-common.sh scripts/start-vnc.sh
```

### Step 3: Start the Container
```bash
./start.sh
```

### Step 4: Connect!

#### Option A: With a Mobile Browser (Recommended for Mobile)
**Using ngrok in Google Cloud Shell (FREE, no card required!)**:

1. **Start the Container**:
   - First, make sure your Ubuntu container is running:
     ```bash
     ./start.sh
     ```

2. **Start ngrok Web Tunnel**:
   - Run the web tunnel start script:
     ```bash
     ./web-tunnel.sh
     ```
   - You'll see something like this:
     ```
     Forwarding  https://abc123.ngrok-free.dev -> http://localhost:6900
     ```
   - Copy the Forwarding URL (like `https://abc123.ngrok-free.dev`)

3. **Open on Your Mobile Browser**:
   - Open your mobile browser and go to the URL you copied, **and add /vnc.html at the end**!
   - For example: `https://abc123.ngrok-free.dev/vnc.html`
   - Enter password: `ubuntu`
   - Click "Connect"!

4. **Use Your Ubuntu Desktop**:
   - You should see the Ubuntu LXDE desktop!
   - You can pinch to zoom, pan around, and use your touchscreen!

#### Option B: With a Browser (Mobile/Desktop)
1. Open your browser and go to: `http://localhost:6900/vnc.html`
2. Enter password: `ubuntu`
3. Click "Connect"!

#### Option C: With Google Cloud Shell
1. Click "Web Preview" in Cloud Shell
2. Select "Preview on port 6900"

## Configuration
You can change settings by editing `start.sh` (the `docker run` command) or by modifying the environment variables in `Dockerfile`:
- `VNC_PORT`: VNC server port (default: 5900)
- `NO_VNC_PORT`: noVNC browser port (default: 6900)
- `VNC_PASSWORD`: VNC password (default: ubuntu)
- `VNC_RESOLUTION`: Screen resolution (default: 1024x768)
- `VNC_DEPTH`: Color depth (default: 24)

## Scripts
- `start.sh`: Start/restart container
- `stop.sh`: Stop/remove container
- `restart.sh`: Restart container
- `update.sh`: Update project and restart
- `healthcheck.sh`: Check container health and logs

## Troubleshooting
- **Container won't start**: Run `./healthcheck.sh` to see logs
- **Forgot password**: Stop the container, delete `data/home/.vnc/passwd`, restart
- **Small screen on mobile**: Adjust `VNC_RESOLUTION` to something like `1080x1920` (portrait) or `1920x1080` (landscape) in `Dockerfile`, then rebuild with `./start.sh`

## Security Notes
Always change the default password! Do not expose ports 5900/6900 to the public internet without a VPN or IP whitelist!

## Backup & Restore
```bash
# Backup
tar -czvf ubuntu-desktop-backup.tar.gz data/

# Restore
tar -xzvf ubuntu-desktop-backup.tar.gz
```

## License
MIT License - see [LICENSE](LICENSE)
