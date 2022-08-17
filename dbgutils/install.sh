#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Starting ttyd..."
  /usr/sbin/ttyd /usr/bin/ash &
fi
