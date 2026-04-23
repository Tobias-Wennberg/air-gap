#!/bin/bash
set -e

# Create stream system user and group (idempotent)
AIRGAP_USER="stream"
AIRGAP_GROUP="stream"

# Detect package type
if [ -f /etc/redhat-release ] || [ -f /etc/rocky-release ]; then
    PKG_TYPE="rpm"
elif [ -f /etc/debian_version ]; then
    PKG_TYPE="deb"
elif [ -f /etc/alpine-release ]; then
    PKG_TYPE="apk"
else
    PKG_TYPE="unknown"
fi

# Create group if doesn't exist
if ! getent group "$AIRGAP_GROUP" >/dev/null 2>&1; then
    echo "Creating stream group..."
    case "$PKG_TYPE" in
        rpm)
            groupadd -r "$AIRGAP_GROUP" 2>/dev/null || true
            ;;
        deb)
            addgroup --system "$AIRGAP_GROUP" 2>/dev/null || true
            ;;
        apk)
            addgroup -S "$AIRGAP_GROUP" 2>/dev/null || true
            ;;
    esac
fi

# Create user if doesn't exist
if ! id "$AIRGAP_USER" >/dev/null 2>&1; then
    echo "Creating stream user..."
    case "$PKG_TYPE" in
        rpm)
            useradd -r -g "$AIRGAP_GROUP" -s /sbin/nologin \
                -d /var/lib/stream -c "Air Gap Service User" "$AIRGAP_USER" 2>/dev/null || true
            ;;
        deb)
            adduser --system --group --no-create-home --home /var/lib/stream \
                --gecos "Air Gap Service User" "$AIRGAP_USER" 2>/dev/null || true
            ;;
        apk)
            adduser -S -G "$AIRGAP_GROUP" -H -h /var/lib/stream \
                -s /sbin/nologin "$AIRGAP_USER" 2>/dev/null || true
            ;;
    esac
fi

echo "✅ Air gap user and group configured"
