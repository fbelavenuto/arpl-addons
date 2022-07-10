#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for Intel(R) Ethernet Connection XL710 adapter"
  ${INSMOD} "/modules/i40e.ko" ${PARAMS}
fi
