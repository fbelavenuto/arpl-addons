#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for Qualcomm Atheros AR816x/AR817x ethernet adapters"
  ${INSMOD} "/modules/alx.ko" ${PARAMS}
fi
