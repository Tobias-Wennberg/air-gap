#!/bin/bash
set -e

PACKAGE_NAME="stream-downstream"

echo "Cleaning up $PACKAGE_NAME..."

# Systemd cleanup
if command -v systemctl >/dev/null 2>&1; then
    systemctl daemon-reload || true
fi

# Note: We don't remove user/group as they might be used by other stream packages
# Note: We don't remove /var/lib/stream or /var/log/stream for data preservation

echo "$PACKAGE_NAME removed"
