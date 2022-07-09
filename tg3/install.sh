#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for Broadcom Tigon3 based gigabit Ethernet cards"
  ${INSMOD} "/modules/tg3.ko" ${PARAMS}
fi
