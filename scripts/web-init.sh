#!/usr/bin/env bash
set -euo pipefail
apt update -y && apt install -y apache2 curl
systemctl enable --now apache2
mkdir -p /var/www/html
printf '\x3Ch1\x3EWEB %s\x3C/h1\x3E\n' "$(hostname)" > /var/www/html/index.html
