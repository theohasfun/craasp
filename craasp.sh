#!/bin/bash

# Setup directories
WORKDIR="/home/chronos/user/kiosk_crx"
APPDIR="$WORKDIR/extracted"
CRX_URL="https://drive.usercontent.google.com/download?id=1-J6ab-LxKKYdDSrTMvUXiRIg9y151SNe&export=download&authuser=0&confirm=t&uuid=0d5c6965-ccf5-48a3-8f61-34d12e96f7aa&at=APcmpoyZxkI-QSL9MzPmTYikeevw:1744352959394"

mkdir -p "$APPDIR"
cd "$WORKDIR" || exit

# Download CRX
curl -sL "$CRX_URL" -o app.crx

# Strip CRX header and extract with bsdtar
dd if=app.crx of=app.zip bs=1 skip=100 status=none
bsdtar -xf app.zip -C "$APPDIR"

# Ensure manifest has kiosk_enabled
MANIFEST="$APPDIR/manifest.json"
if [ -f "$MANIFEST" ] && ! grep -q '"kiosk_enabled"' "$MANIFEST"; then
  tmpfile=$(mktemp)
  jq '. + {"kiosk_enabled": true}' "$MANIFEST" > "$tmpfile" && mv "$tmpfile" "$MANIFEST"
fi

# Create launch script
cat <<EOF > "$WORKDIR/launch_kiosk.sh"
#!/bin/bash
exec /opt/google/chrome/chrome --kiosk --load-and-launch-app=$APPDIR
EOF

chmod +x "$WORKDIR/launch_kiosk.sh"

# Run the app
"$WORKDIR/launch_kiosk.sh"
