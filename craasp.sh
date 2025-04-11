#!/bin/bash

# Create working directory
mkdir -p /home/chronos/user/kiosk_crx
cd /home/chronos/user/kiosk_crx || exit

# Download CRX
curl -L "https://drive.usercontent.google.com/download?id=1-J6ab-LxKKYdDSrTMvUXiRIg9y151SNe&export=download&authuser=0&confirm=t&uuid=0d5c6965-ccf5-48a3-8f61-34d12e96f7aa&at=APcmpoyZxkI-QSL9MzPmTYikeevw:1744352959394" -o app.crx

# Extract CRX (strip header, unzip)
dd if=app.crx of=app.zip bs=1 skip=100 status=none
unzip -o app.zip -d extracted

# Patch manifest to enable kiosk if missing
if ! grep -q '"kiosk_enabled"' extracted/manifest.json; then
  sed -i '2i\  "kiosk_enabled": true,' extracted/manifest.json
fi

# Create launch script
cat <<EOF > /home/chronos/user/kiosk_crx/launch_kiosk.sh
#!/bin/bash
/opt/google/chrome/chrome --kiosk --load-and-launch-app=/home/chronos/user/kiosk_crx/extracted
EOF

chmod +x /home/chronos/user/kiosk_crx/launch_kiosk.sh

# Run it
/home/chronos/user/kiosk_crx/launch_kiosk.sh
