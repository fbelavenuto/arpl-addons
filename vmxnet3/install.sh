#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for VMware vmxnet3 virtual NIC adapter"
  ${INSMOD} "/modules/vmxnet3.ko" ${PARAMS}
fi
