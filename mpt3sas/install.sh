#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Installing module for LSI MPT Fusion SAS 3.0 Device adapter"
  ${INSMOD} "/modules/raid_class.ko"
  ${INSMOD} "/modules/scsi_transport_sas.ko"
  ${INSMOD} "/modules/mpt3sas.ko" ${PARAMS}
fi
