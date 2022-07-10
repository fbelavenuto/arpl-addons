#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for Avago MegaRAID SAS adapter"
  ${INSMOD} "/modules/megaraid_sas.ko" ${PARAMS}
fi
