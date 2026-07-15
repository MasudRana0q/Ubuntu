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
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh web-tunnel.sh tcp-tunnel.sh setup-ngrok.sh scripts/docker-common.sh scripts/ngrok-common.sh scripts/start-vnc.sh
```

### Step 3: Start the Container
```bash
./start.sh
```

### Step 4: Connect!

### First-Time ngrok Setup for RVNC Viewer
```bash
./setup-ngrok.sh YOUR_NGROK_AUTHTOKEN
```

### One Command for Mobile RVNC
```bash
./start.sh mobile
```

### Rebuild Only When Needed
```bash
./start.sh rebuild
```

### Pull From Docker Hub Instead of Building
```bash
IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh pull
```

### Pull From Docker Hub and Open RVNC Tunnel
```bash
IMAGE_NAME=masudgolp/ubuntu-desktop-vnc ./start.sh mobile-pull
```

### Mount Your Cloud Shell Upload Folder
To see files you upload to your Google Cloud Shell home directory directly inside the container:

1. Set the environment variable and start:
   ```bash
   # Replace /home/masud0q with your actual Cloud Shell home path
   export HOST_UPLOAD_FOLDER="/home/masud0q"
   ./start.sh mobile
   ```

2. Inside the container/VNC OS:
   - Open file manager and go to `/cloudshell-uploads/`
   - All your uploaded files will be there!

**Note**: For safety, this is optional and defaults off. Use only if you want this feature.

#### Option A: With RVNC Viewer (Recommended for Mobile)
**Using ngrok TCP tunnel in Google Cloud Shell**:

1. **Save your ngrok token once**:
   ```bash
   ./setup-ngrok.sh YOUR_NGROK_AUTHTOKEN
   ```

2. **Start everything with one command**:
   ```bash
   ./start.sh mobile
   ```

3. **Copy the TCP forwarding address**:
   - You'll see something like:
     ```
     Forwarding  tcp://0.tcp.ngrok.io:12345 -> localhost:5900
     ```
   - In RVNC Viewer:
     - Host: `0.tcp.ngrok.io`
     - Port: `12345`
     - Password: `ubuntu`

#### Option B: With a Mobile Browser
**Using ngrok web tunnel in Google Cloud Shell**:

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

#### Option C: With a Browser (Mobile/Desktop)
1. Open your browser and go to: `http://localhost:6900/vnc.html`
2. Enter password: `ubuntu`
3. Click "Connect"!

#### Option D: With Google Cloud Shell
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
- **Need a bit more height on mobile**: Default resolution is set to `1024x900` so the desktop gets a little more vertical space without making everything too small

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
