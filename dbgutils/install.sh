#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Starting ttyd..."
  /usr/sbin/ttyd /usr/bin/ash &
elif [ "${1}" = "late" ]; then
  echo "Killing ttyd..."
  /usr/bin/killall ttyd
fi
