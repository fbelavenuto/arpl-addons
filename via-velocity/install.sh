#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for VIA Networking Velocity Family Gigabit Ethernet Adapter"
  ${INSMOD} "/modules/crc-ccitt.ko"
  ${INSMOD} "/modules/via-velocity.ko" ${PARAMS}
fi
