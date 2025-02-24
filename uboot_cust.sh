#!/bin/bash

# File paths
ENV_TEXT_FILE="uboot_env.txt"  # Temporary text file for U-Boot env
ENV_BIN_FILE="uboot.env"       # Binary U-Boot environment file

# U-Boot environment variables
cat << EOF > "$ENV_TEXT_FILE"
# Initial boot delay (seconds) for "Hit any key to stop autoboot"
bootdelay=3

# Custom boot command with secondary delay
bootcmd=echo "ZynqMP> Autoboot in 120 seconds unless interrupted..."; sleep 120; if test \$? -eq 0; then echo "Booting now..."; boot; else echo "Boot interrupted"; fi

# Default boot command if not overridden
bootargs=console=ttyPS0,115200 root=/dev/mmcblk0p2 rw rootwait
bootimage=BOOT.BIN
EOF

# Convert text file to U-Boot binary environment file
# Requires 'mkenvimage' from U-Boot tools (install u-boot-tools on your system)
mkenvimage -s 16384 -o "$ENV_BIN_FILE" "$ENV_TEXT_FILE"

if [ $? -eq 0 ]; then
    echo "Generated $ENV_BIN_FILE successfully."
    echo "Copy $ENV_BIN_FILE to your SD card's boot partition or use it to update the environment."
else
    echo "Error generating $ENV_BIN_FILE. Ensure 'mkenvimage' is installed."
    exit 1
fi
