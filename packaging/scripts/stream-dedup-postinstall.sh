#!/bin/bash
set -e

AIRGAP_USER="stream"
AIRGAP_GROUP="stream"
PACKAGE_NAME="stream-dedup"

echo "Configuring $PACKAGE_NAME..."

# Create runtime directories
mkdir -p /opt/stream/dedup
mkdir -p /var/lib/stream/dedup
mkdir -p /var/lib/stream/create
mkdir -p /var/log/stream
mkdir -p /etc/stream
mkdir -p /etc/default

# Set ownership
chown -R "$AIRGAP_USER:$AIRGAP_GROUP" /opt/stream/dedup
chown -R "$AIRGAP_USER:$AIRGAP_GROUP" /var/lib/stream/dedup
chown -R "$AIRGAP_USER:$AIRGAP_GROUP" /var/lib/stream/create
chown -R "$AIRGAP_USER:$AIRGAP_GROUP" /var/log/stream
chmod 755 /opt/stream/dedup /var/lib/stream/dedup /var/lib/stream/create /var/log/stream

# Config directory (root-owned)
chown root:root /etc/stream
chmod 755 /etc/stream

# Check Java
if ! command -v java >/dev/null 2>&1; then
    echo "WARNING: Java runtime not found!"
fi

# Systemd integration
if command -v systemctl >/dev/null 2>&1 && systemctl is-system-running >/dev/null 2>&1; then
    systemctl daemon-reload
    
    echo "$PACKAGE_NAME installed successfully"
fi
