#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for Neterion's X3100 Series 10GbE PCIe I/OVirtualized Server adapter"
  ${INSMOD} "/modules/vxge.ko" ${PARAMS}
fi
