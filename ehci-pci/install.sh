#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing modules for ehci-pci"
  ${INSMOD} "/modules/ehci-hcd.ko"
  ${INSMOD} "/modules/ehci-pci.ko" ${PARAMS}
fi
