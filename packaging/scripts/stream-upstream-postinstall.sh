#!/bin/bash
set -e

AIRGAP_USER="stream"
AIRGAP_GROUP="stream"
PACKAGE_NAME="stream-upstream"

echo "Configuring $PACKAGE_NAME..."

# Create runtime directories
mkdir -p /var/lib/stream/upstream
mkdir -p /var/lib/stream/resend
mkdir -p /var/log/stream
mkdir -p /etc/stream
mkdir -p /etc/default

# Set ownership
chown -R "$AIRGAP_USER:$AIRGAP_GROUP" /var/lib/stream
chown -R "$AIRGAP_USER:$AIRGAP_GROUP" /var/log/stream
chmod 755 /var/lib/stream /var/log/stream

# Config directory (root-owned)
chown root:root /etc/stream
chmod 755 /etc/stream

# Systemd integration
if command -v systemctl >/dev/null 2>&1 && systemctl is-system-running >/dev/null 2>&1; then
    echo "Reloading systemd daemon..."
    systemctl daemon-reload
    
    echo "$PACKAGE_NAME installed successfully"
fi
