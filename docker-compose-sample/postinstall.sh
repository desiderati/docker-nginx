#!/bin/bash
DIR="$(dirname "${BASH_SOURCE[0]}")"
DIR="$(cd "$DIR" >/dev/null 2>&1 && pwd)"

echo "[$(date +%c)] Applying ACL fix for directory: $DIR/logs/..."
sudo setfacl -R -d -m u::rw- "$DIR"/logs/
sudo setfacl -R -m g::rw- "$DIR"/logs/
sudo setfacl -R -m o::r-- "$DIR"/logs/

echo "[$(date +%c)] Applying fix for application ownership..."
sudo find "$DIR" -exec chown "$UID":"$UID" {} +

echo "[$(date +%c)] Applying file access permissions fix..."
sudo find "$DIR" -type f -exec chmod u+rw,g+rw,o=r {} \;

echo "[$(date +%c)] Applying directory access permissions fix..."
sudo find "$DIR" -type d -exec chmod u=rwx,g=rwx,o=rx {} \;
