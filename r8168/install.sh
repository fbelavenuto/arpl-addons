#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for Realtek R8168/8111 Ethernet adapter"
  ${INSMOD} "/modules/r8168.ko" ${PARAMS}
fi
