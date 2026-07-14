# Ubuntu Desktop for Mobile (VNC + Browser)

Production-ready Docker project for Ubuntu Desktop (LXDE) with TigerVNC, optimized for **mobile VNC clients** (AVNC, RealVNC Viewer, RVNC) and Google Cloud Shell!

## Features
- 📱 **Optimized for Mobile**: Works great with VNC clients
- 🖥️ Ubuntu 22.04 (compatible with older Docker versions)
- 🔒 TigerVNC (secure, widely supported)
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
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh scripts/docker-common.sh scripts/start-vnc.sh
```

### Step 3: Start the Container
```bash
./start.sh
```

### Step 4: Connect!

#### Option A: With a VNC Client (Recommended for Mobile)
1. Install a VNC client like **AVNC** (Android) or **RealVNC Viewer** (iOS/Android)
2. Add a new connection:
   - Host: `localhost` (or your server's IP address)
   - Port: `5900`
   - Password: `ubuntu`
3. Connect!

#### Option B: With Google Cloud Shell
1. Click "Web Preview" in Cloud Shell
2. Select "Preview on port 5900"

## Configuration
You can change settings by editing `start.sh` (the `docker run` command) or by modifying the environment variables in `Dockerfile`:
- `VNC_PORT`: VNC server port (default: 5900)
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
Always change the default password! Do not expose port 5900 to the public internet without a VPN or IP whitelist!

## Backup & Restore
```bash
# Backup
tar -czvf ubuntu-desktop-backup.tar.gz data/

# Restore
tar -xzvf ubuntu-desktop-backup.tar.gz
```

## License
MIT License - see [LICENSE](LICENSE)
