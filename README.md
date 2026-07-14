# Ubuntu Desktop with KasmVNC for Google Cloud Shell

A production-quality Docker project that runs Ubuntu Desktop (XFCE) with KasmVNC, optimized for Google Cloud Shell and mobile devices.

## Features

- 🖥️ Ubuntu 24.04 with XFCE Desktop Environment
- 🔒 KasmVNC for secure remote access
- 📱 Mobile-optimized interface
- 📂 Shared folder support
- 💾 Persistent data storage
- 👤 Password authentication
- 🩺 Health check
- 🔄 Auto restart
- 📊 Logging

## Requirements

- Docker
- Docker Compose

## Quick Start

### 1. Clone the Repository

```bash
git clone <your-repository-url>
cd Ubuntu
```

### 2. Make Scripts Executable

```bash
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh
```

### 3. Start the Container

```bash
./start.sh
```

### 4. Access the Desktop

Open your browser and navigate to:
`http://localhost:6901`

Default password: `ubuntu`

## Google Cloud Shell Setup

### Step 1: Open Google Cloud Shell

Go to [Google Cloud Console](https://console.cloud.google.com/) and open Cloud Shell.

### Step 2: Clone the Repository

```bash
git clone <your-repository-url>
cd Ubuntu
```

### Step 3: Make Scripts Executable

```bash
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh
```

### Step 4: Start the Container

```bash
./start.sh
```

### Step 5: Access via Web Preview

Click on "Web Preview" in Cloud Shell and select "Preview on port 6901".

### Google Cloud Shell Limitations

1. **Session Timeout**: Cloud Shell sessions timeout after 1 hour of inactivity.
2. **Storage**: Persistent storage is limited to 5 GB.
3. **Resource Limits**: CPU and memory are limited.

**Alternative**: For long-term use, deploy on Google Compute Engine or another VPS.

## Mobile Access

### Via Browser

1. Open your mobile browser.
2. Navigate to the access URL (Cloud Shell Web Preview or your server URL).
3. Enter the password.

### Via VNC Client

1. Install a VNC client like AVNC, bVNC, or RealVNC Viewer on your mobile device.
2. Configure the connection:
   - Host: Your server address
   - Port: 6901
   - Password: Your VNC password
3. Connect!

## Configuration

### Environment Variables

Edit `docker-compose.yml` to customize:

- `VNC_PORT`: VNC server port (default: 6901)
- `VNC_PASSWORD`: VNC password (default: ubuntu)
- `VNC_RESOLUTION`: Screen resolution (default: 1280x720)

### Persistent Storage

- `data/home/`: User home directory
- `data/shared/`: Shared folder

## Scripts

- `start.sh`: Start the container
- `stop.sh`: Stop the container
- `restart.sh`: Restart the container
- `update.sh`: Update the project and restart
- `healthcheck.sh`: Check container health

## Troubleshooting

### Container won't start

```bash
./healthcheck.sh
docker compose logs
```

### Can't access the desktop

- Check if port 6901 is open
- Verify the container is running: `docker compose ps`

### Forgot password

1. Stop the container: `./stop.sh`
2. Edit `docker-compose.yml` to change `VNC_PASSWORD`
3. Start again: `./start.sh`

## Security Notes

- **Change the default password** immediately!
- Do not expose port 6901 to the public internet without proper security (VPN, IP whitelisting, etc.).
- Use HTTPS if possible.

## Backup & Restore

### Backup

```bash
tar -czvf backup.tar.gz data/
```

### Restore

```bash
tar -xzvf backup.tar.gz
```

## License

MIT License - see [LICENSE](LICENSE) file for details.
