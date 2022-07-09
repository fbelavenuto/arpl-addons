#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for VMware PVSCSI adapter"
  ${INSMOD} "/modules/vmw_pvscsi.ko" ${PARAMS}
fi
