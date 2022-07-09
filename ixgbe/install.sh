#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for Intel(R) 10GbE PCI Express adapters"
  ${INSMOD} "/modules/mdio.ko"
  ${INSMOD} "/modules/ixgbe.ko" ${PARAMS}
fi
