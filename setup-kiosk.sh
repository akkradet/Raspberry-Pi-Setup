#!/bin/bash
# Raspberry Pi 5 Kiosk Auto Setup (Bookworm)

set -e

echo "=== Update & Install Packages ==="
sudo apt update && sudo apt upgrade -y
sudo apt install --no-install-recommends \
  xserver-xorg x11-xserver-utils xinit openbox \
  chromium-browser unclutter xdotool -y

echo "=== Enable Console Autologin ==="
# B2 = Console Autologin
sudo raspi-config nonint do_boot_behaviour B2

echo "=== Setup autostart X on login ==="
BASH_PROFILE="/home/pi/.bash_profile"
if ! grep -q "startx" $BASH_PROFILE 2>/dev/null; then
  echo '[[ -z $DISPLAY && $XDG_VTNR -eq 1 ]] && exec startx' >> $BASH_PROFILE
fi

echo "=== Create ~/.xinitrc ==="
cat > /home/pi/.xinitrc <<'EOF'
#!/bin/bash
xset s noblank
xset s off
xset -dpms
unclutter -idle 0.5 -root &

PREFS="/home/pi/.config/chromium/Default/Preferences"
if [ -f "$PREFS" ]; then
  sed -i 's/"exited_cleanly":false/"exited_cleanly":true/' "$PREFS" || true
  sed -i 's/"exit_type":"Crashed"/"exit_type":"Normal"/' "$PREFS" || true
fi

# URLs
URLS=" \
http://192.168.11.163/quality_control/slide1.php?line=1 \
http://192.168.11.163/quality_control/slide2.php?line=1 \
http://192.168.11.163/quality_control/slide3.php?line=1 \
http://192.168.11.163/quality_control/slide1.php?line=3 \
http://192.168.11.163/quality_control/slide2.php?line=3 \
http://192.168.11.163/quality_control/slide3.php?line=3 \
http://192.168.11.163/quality_control/slide1.php?line=4 \
http://192.168.11.163/quality_control/slide2.php?line=4 \
http://192.168.11.163/quality_control/slide3.php?line=4 \
"

chromium-browser \
  --noerrdialogs \
  --disable-features=Translate \
  --disable-component-update \
  --disable-infobars \
  --start-fullscreen \
  --kiosk \
  --use-gl=egl \
  $URLS &

while true; do
    xdotool keydown ctrl+Tab; xdotool keyup ctrl+Tab
    xdotool key F5
    sleep 30
done
EOF

chown pi:pi /home/pi/.xinitrc
chmod +x /home/pi/.xinitrc

echo "=== Create systemd service for auto restart ==="
SERVICE_FILE="/etc/systemd/system/kiosk.service"
sudo tee $SERVICE_FILE > /dev/null <<'EOF'
[Unit]
Description=Chromium Kiosk
After=graphical.target

[Service]
User=pi
Environment=DISPLAY=:0
ExecStart=/bin/bash -lc startx
Restart=always
RestartSec=5s

[Install]
WantedBy=graphical.target
EOF

echo "=== Enable Kiosk service ==="
sudo systemctl daemon-reexec
sudo systemctl enable kiosk.service

echo "=== Setup Done! Please reboot ==="
