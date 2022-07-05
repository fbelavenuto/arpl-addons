if [ "${1}" = "rd" ]; then
  echo "Installing module for Areca ARC11xx/12xx/16xx/188x SAS/SATA RAID Controller"
  ${INSMOD} "/modules/arcmsr.ko" ${PARAMS}
fi
