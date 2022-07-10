#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for Intel(R) PRO/1000 Gigabit Ethernet PCI-e adapter"
  ${INSMOD} "/modules/e1000e.ko" ${PARAMS}
fi
