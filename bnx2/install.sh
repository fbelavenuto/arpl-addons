#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing Broadcom Netxtreme Gigabit Ethernet Driver"
  tar -zxvf /addons/bnx2.tgz -C /tmpRoot/
  chmod 755 /tmpRoot/usr/lib/firmware/bnx2/*.fw
fi
