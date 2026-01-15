#!/bin/bash
# Install ADSBExchange feeder for track_planes

set -e

IPATH=/usr/local/share/adsbexchange
UNAME=adsbexchange

echo "Installing ADSBExchange feeder..."

# Create user
echo "Creating adsbexchange user..."
sudo useradd --system --home-dir "$IPATH" --no-create-home "$UNAME" 2>/dev/null || echo "User $UNAME already exists"

# Create directories
sudo mkdir -p "$IPATH"
sudo mkdir -p /var/log/adsbexchange
sudo mkdir -p /run/adsbexchange-feed

# Clone repository if not exists
if [ ! -d "$IPATH/git" ]; then
    echo "Cloning ADSBExchange repository..."
    sudo git clone https://github.com/adsbexchange/feedclient.git "$IPATH/git"
else
    echo "Updating ADSBExchange repository..."
    sudo git -C "$IPATH/git" pull
fi

# Set permissions
sudo chown -R "$UNAME:$UNAME" "$IPATH" 2>/dev/null || true
sudo chown -R "$UNAME:$UNAME" /var/log/adsbexchange 2>/dev/null || true
sudo chown -R "$UNAME:$UNAME" /run/adsbexchange-feed 2>/dev/null || true
sudo chmod 755 "$IPATH/git/scripts"/*.sh

# Copy configuration files
echo "Installing configuration files..."
sudo cp /root/etc/default/adsbexchange /etc/default/adsbexchange || true
sudo cp /root/etc/systemd/system/adsbexchange-*.service /etc/systemd/system/ || true

# Reload systemd and enable services
echo "Enabling services..."
sudo systemctl daemon-reload
sudo systemctl enable adsbexchange-feed
sudo systemctl enable adsbexchange-mlat

# Start services
echo "Starting ADSBExchange services..."
sudo systemctl start adsbexchange-feed

echo "ADSBExchange installation complete!"
echo "Check status with: systemctl status adsbexchange-feed"
echo "View logs with: sudo journalctl -u adsbexchange-feed -f"
