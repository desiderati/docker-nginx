#!/bin/bash
DIR="$(dirname "${BASH_SOURCE[0]}")"
DIR="$(cd "$DIR" >/dev/null 2>&1 && pwd)"

echo "[$(date +%c)] Aplicando a correção do ACL para o diretório: $DIR/logs/..."
sudo setfacl -R -d -m u::rw- "$DIR"/logs/
sudo setfacl -R -m g::rw- "$DIR"/logs/
sudo setfacl -R -m o::r-- "$DIR"/logs/

echo "[$(date +%c)] Aplicando a correção para o Owner da aplicação..."
sudo find "$DIR" -exec chown "$UID":"$UID" {} +

echo "[$(date +%c)] Aplicando a correção de acesso aos arquivos da aplicação..."
sudo find "$DIR" -type f -exec chmod u+rw,g+rw,o=r {} \;

echo "[$(date +%c)] Aplicando a correção de acesso aos diretórios da aplicação..."
sudo find "$DIR" -type d -exec chmod u=rwx,g=rwx,o=rx {} \;
