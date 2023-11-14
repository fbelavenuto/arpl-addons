#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing addon rtcwake"
  gzip -dc /addons/rtcwake.gz > /tmpRoot/usr/sbin/rtcwake
  chmod +x /tmpRoot/usr/sbin/rtcwake
fi
