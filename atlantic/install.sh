#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for aQuantia AQtion(tm) Ethernet card"
  ${INSMOD} "/modules/atlantic.ko" ${PARAMS}
fi
