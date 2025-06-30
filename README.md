# 🛒 Crash Cart

**Crash Cart** is a plug-and-play HDMI capture streamer in a Docker container. Designed for IT admins, makers, and hardware wranglers, it lets you view the screen of any HDMI device (server, SBC, camera, console) through a web browser—no monitor required.

Just plug in a USB HDMI capture device, run the container, and view the live feed from any device on your network.

---

## 📦 Features

- 🔌 Zero-config: auto-detects `/dev/video` capture devices
- 🌐 Web UI: stream available at `http://<ip>:8080/`
- ⚡ Fast load time with ultra-minimal Alpine base (~50MB image)
- 🔁 MJPEG stream via HTTP (instant preview in most browsers)
- 🔧 Configurable resolution & frame rate using environment variables
- 🐳 Multi-arch support (`armv7`, `amd64`)—works on Raspberry Pi, Jetson, etc.
- 🛡️ Optional password protection or local network-only access

---

## 🚀 Quick Start

1. **Plug in your USB HDMI capture device**

2. **Run the container:**

```yaml
services:
  crashcart:
    image: ghcr.io/gusvendegna/crashcart:latest
    container_name: crashcart
    ports:
      - "8080:8080"
    devices:
      - "/dev/video0:/dev/video0"
    environment:
      - RESOLUTION=1280x720
      - FRAMERATE=30
    restart: unless-stopped
```

3. **Open your browser:**

```
http://<your-device-ip>:8080/
```

Done. You’re now streaming live.

---

## ⚙️ Environment Variables

| Variable     | Default     | Description                      |
|--------------|-------------|----------------------------------|
| `RESOLUTION` | `1280x720`  | Capture resolution (`WxH`)       |
| `FRAMERATE`  | `30`        | Capture frame rate               |

---

## 🛠️ Build Locally

```bash
docker buildx build \
  --platform linux/arm/v7 \
  -t crash-cart:local \
  --load .
```

---

## 🧪 Development Notes

- Built on MJPG-streamer with UVC input and HTTP output
- Static web UI replaces default streamer page with autoplay setup
- Use `v4l2-ctl --list-formats-ext -d /dev/video0` to check supported modes
- Customize `/www/index.html` to modify appearance

---

## 🔐 Optional: Secure Your Stream

To restrict access, consider:
- Running behind a reverse proxy with basic auth
- Enabling local network firewall rules
- Tunneling over SSH/VPN

---

## 📚 Credits

- MJPG-Streamer by [jacksonliam](https://github.com/jacksonliam/mjpg-streamer)
- Maintained & packaged by [@gusvendegna]
