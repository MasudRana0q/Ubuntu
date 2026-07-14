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
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh ngrok-start.sh scripts/docker-common.sh scripts/start-vnc.sh
```

### Step 3: Start the Container
```bash
./start.sh
```

### Step 4: Connect!

#### Option A: With a Mobile VNC Client (Recommended for Mobile)
**Using ngrok in Google Cloud Shell**:

1. **Install ngrok and Configure Auth Token**:
   - First, make sure your Ubuntu container is running with `./start.sh`
   - Go to https://ngrok.com, sign up for a free account, and get your auth token from https://dashboard.ngrok.com/get-started/your-authtoken
   - In Cloud Shell, set your auth token:
     ```bash
     ngrok config add-authtoken YOUR_AUTH_TOKEN
     ```

2. **Start ngrok Tunnel**:
   - Run the ngrok start script:
     ```bash
     ./ngrok-start.sh
     ```
   - You'll see something like this:
     ```
     Forwarding  tcp://0.tcp.ngrok.io:12345 -> localhost:5900
     ```
   - Copy the Forwarding address (like `0.tcp.ngrok.io:12345`)

3. **Install a VNC Client on Your Phone**:
   - For Android: Install **AVNC** (free, open source) or **RealVNC Viewer** from Google Play Store
   - For iOS: Install **RealVNC Viewer** from App Store

4. **Configure Connection**:
   - Open your VNC client
   - Add a new connection
   - Host: Use the ngrok address you copied (like `0.tcp.ngrok.io`)
   - Port: Use the ngrok port (like `12345`)
   - Password: `ubuntu` (change this later for security!)
   - Save the connection

5. **Connect**:
   - Tap the connection to connect
   - You should see the Ubuntu LXDE desktop!
   - You can pinch to zoom, pan around, and use your touchscreen as a mouse!

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
