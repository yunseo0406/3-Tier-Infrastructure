#!/usr/bin/env bash
set -euo pipefail
apt update -y && apt install -y tomcat9 curl coreutils
systemctl enable --now tomcat9
WEBAPPS=/var/lib/tomcat9/webapps
mkdir -p "$WEBAPPS/ROOT"
cat > /tmp/index.jsp.b64 <<'B64'
PGh0bWw+PGJvZHk+PGgxPldBUyBKU1AgT0s6IDwlcw0KICBvdXQucHJpbnQoaW8uamF2YS5uZXQuSW5ldEFkZHJlc3MuZ2V0TG9jYWxIb3N0KCkuZ2V0SG9zdE5hbWUoKSkpOw0KJSB8fCBlLmNscygpOw0KJT4NClxuPC9oMT48L2JvZHk+PC9odG1sPg==
B64
base64 -d /tmp/index.jsp.b64 > "$WEBAPPS/ROOT/index.jsp"
rm -f /tmp/index.jsp.b64
