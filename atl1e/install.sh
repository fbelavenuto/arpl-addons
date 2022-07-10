#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for Atheros L1E Gigabit Ethernet adapter"
  ${INSMOD} "/modules/atl1e.ko" ${PARAMS}
fi
