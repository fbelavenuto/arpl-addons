#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for LSI MPT Fusion SAS 3.0 Device adapter"
  ${INSMOD} "/modules/mpt3sas.ko" ${PARAMS}
fi
