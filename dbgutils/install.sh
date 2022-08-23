#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Starting ttyd..."
  /usr/sbin/ttyd /usr/bin/ash &
elif [ "${1}" = "late" ]; then
  echo "Killing ttyd..."
  /usr/bin/killall ttyd
  echo "Copying utils"
  cp -vf /usr/bin/dtc    /tmpRoot/usr/bin/
  cp -vf /usr/bin/lsscsi /tmpRoot/usr/bin/
  cp -vf /usr/bin/nano   /tmpRoot/usr/bin/
  cp -vf /usr/bin/strace /tmpRoot/usr/bin/
  cp -vf /usr/sbin/ttyd  /tmpRoot/usr/sbin/
  ln -sf /usr/bin/kmod   /tmpRoot/usr/sbin/modinfo
fi
