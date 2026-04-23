#!/bin/bash
set -e

PACKAGE_NAME="stream-upstream"

echo "Cleaning up $PACKAGE_NAME..."

# Systemd cleanup
if command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload || true
fi

echo "$PACKAGE_NAME removed"
