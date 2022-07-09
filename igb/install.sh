#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for Intel(R) 82575 PCI-Express ethernet adapter"
  ${INSMOD} "/modules/igb.ko" ${PARAMS}
fi
