#!/usr/bin/env ash

if [ "${1}" = "early" -o "${1}" = "modules" ]; then
  echo "Installing module for Broadcom NetXtremeII 10Gb adapter"
  ${INSMOD} "/modules/mdio.ko"
  ${INSMOD} "/modules/libcrc32c.ko"
  ${INSMOD} "/modules/bnx2x.ko" ${PARAMS}
fi
