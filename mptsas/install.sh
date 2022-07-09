#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Installing module for Fusion MPT ScsiHost for SAS"
  ${INSMOD} "/modules/scsi_transport_sas.ko"
  ${INSMOD} "/modules/mptbase.ko"
  ${INSMOD} "/modules/mptscsih.ko"
  ${INSMOD} "/modules/mptsas.ko" ${PARAMS}
fi
