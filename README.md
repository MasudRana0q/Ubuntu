# Ubuntu Desktop with KasmVNC

Production-ready Docker project for running an Ubuntu XFCE desktop with KasmVNC. The repository is designed to work locally and in Google Cloud Shell, with Cloud Shell-compatible helper scripts that use plain Docker instead of the legacy `docker-compose` client.

## Features

- Ubuntu 24.04 base image
- XFCE desktop environment
- KasmVNC browser-based desktop access
- Firefox, Thunar, and XFCE Terminal
- Persistent home and shared folders
- Password-based login
- Health check script
- Auto-restart container policy
- Google Cloud Shell-friendly startup flow
- Mobile browser support

## Requirements

### Local machine

- Docker Engine 24+ recommended
- Docker Compose v2 optional
- 4 GB RAM recommended
- 10 GB free disk space recommended

### Google Cloud Shell

- Cloud Shell with Docker support enabled
- Enough temporary disk space for image build layers
- Browser access through Cloud Shell Web Preview

## Clone

```bash
git clone https://github.com/MasudRana0q/Ubuntu.git
cd Ubuntu
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh
```

## Installation

No extra host installation is required beyond Docker. The first run builds the image automatically.

## Build

### Recommended

```bash
./start.sh
```

### Manual local build

```bash
docker build -t ubuntu-desktop-kasm:latest .
```

## Run

### Local machine

```bash
./start.sh
```

Open `http://localhost:6901` in your browser.

### Google Cloud Shell

Use a writable directory such as `/tmp`:

```bash
cd /tmp
git clone https://github.com/MasudRana0q/Ubuntu.git
cd Ubuntu
chmod +x start.sh stop.sh restart.sh update.sh healthcheck.sh
./start.sh
```

Then open Cloud Shell `Web Preview` for port `6901`.

## Stop

```bash
./stop.sh
```

## Restart

```bash
./restart.sh
```

## Update

```bash
./update.sh
```

## Configuration

The helper scripts read these environment variables:

- `VNC_PORT`: host port for browser access, default `6901`
- `VNC_PASSWORD`: desktop login password, default `ubuntu`
- `VNC_RESOLUTION`: desktop resolution, default `1280x720`
- `IMAGE_NAME`: Docker image name, default `ubuntu-desktop-kasm`
- `CONTAINER_NAME`: container name, default `ubuntu-desktop`
- `DATA_HOME`: persistent home folder path, default `./data/home`
- `DATA_SHARED`: shared folder path, default `./data/shared`

Example:

```bash
export VNC_PASSWORD='StrongPassword123'
export VNC_RESOLUTION='1600x900'
./start.sh
```

## Storage

- `data/home`: persistent Linux home directory inside the container
- `data/shared`: shared folder mounted to `/shared`
- `.runtime/docker-config`: temporary Docker client config used by the scripts to avoid Cloud Shell permission issues

## Mobile Support

### Google Cloud Shell

- Supported method: browser only
- Recommended flow: open Cloud Shell Web Preview for port `6901`
- Reason: Cloud Shell exposes browser preview URLs, not a raw public TCP port for VNC clients
- Result: apps like AVNC, bVNC, and RealVNC Viewer are not the right choice for Cloud Shell

### Google Compute Engine or VPS

- Supported methods: browser and raw VNC client
- Browser URL: `http://SERVER_IP:6901`
- VNC host: `SERVER_IP`
- VNC port: `6901`
- Password source: `VNC_PASSWORD`
- Security recommendation: place the service behind HTTPS reverse proxy, VPN, or firewall allow-list

## Google Cloud Shell Limitations

- Session lifecycle: Cloud Shell sessions are temporary and can stop unexpectedly
- Disk space: storage is limited, so large image rebuilds may fail
- Old compose client: Cloud Shell may include a legacy `docker-compose` binary that cannot talk to the current Docker daemon
- Port exposure: Web Preview works for browser access, but direct mobile VNC clients cannot connect through Cloud Shell
- Background usage: this is not suitable for always-on desktop hosting

## Recommended Production Alternative

For reliable long-term use, run this repository on Google Compute Engine, an Ubuntu VPS, or any VM where you control:

- Docker version
- firewall rules
- public IP
- persistent disks
- TLS and reverse proxy

## Troubleshooting

### Start script fails with Docker config permission denied

The bundled scripts already redirect Docker client config into `.runtime/docker-config`. Re-clone or pull the latest version and run `./start.sh` again.

### Start script fails with old Docker Compose API version

Use the latest scripts from this repository. They no longer require `docker-compose` for the normal run path.

### Container exists but desktop is unavailable

```bash
./healthcheck.sh
docker logs --tail 100 ubuntu-desktop
```

### KasmVNC page opens but login fails

- verify `VNC_PASSWORD`
- remove old persistent state from `data/home/.vnc` if needed
- restart with `./restart.sh`

### Build fails in Cloud Shell

Possible causes:

- not enough disk space
- Cloud Shell Docker service unavailable
- upstream package mirror temporary failure

Practical fallback:

- rebuild later in a fresh session
- run the same project on Google Compute Engine or another VPS

## FAQ

### Can I use RealVNC Viewer or AVNC in Google Cloud Shell?

No. In Cloud Shell you should use browser access through Web Preview.

### Can I use RealVNC Viewer or AVNC on a VPS?

Yes. Expose TCP port `6901`, secure it properly, and connect with the same password configured by `VNC_PASSWORD`.

### Does `docker-compose.yml` still matter?

Yes. It remains available for local environments with modern Compose support, but the helper scripts intentionally use direct Docker commands for maximum Cloud Shell compatibility.

## Security Notes

- Change the default password before exposing the service anywhere
- Do not publish port `6901` directly to the public internet without firewall controls
- Prefer HTTPS reverse proxy for browser access on VPS deployments
- Treat the desktop as an internet-facing service if exposed publicly

## Backup

```bash
tar -czvf ubuntu-desktop-backup.tar.gz data
```

## Restore

```bash
tar -xzvf ubuntu-desktop-backup.tar.gz
```

## License

This project is licensed under the MIT License. See `LICENSE`.
