#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for Marvell Yukon 2 Gigabit Ethernet adapter"
  ${INSMOD} "/modules/sky2.ko" ${PARAMS}
fi
