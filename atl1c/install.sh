#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for Atheros L1C Gigabit Ethernet adapter"
  ${INSMOD} "/modules/atl1c.ko" ${PARAMS}
fi
