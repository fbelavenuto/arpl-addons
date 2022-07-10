#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for Marvell Yukon Gigabit Ethernet adapter"
  ${INSMOD} "/modules/skge.ko" ${PARAMS}
fi
