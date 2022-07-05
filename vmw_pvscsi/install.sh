if [ "${1}" = "rd" ]; then
  echo "Installing module for VMware PVSCSI adapter"
  ${INSMOD} "/modules/vmw_pvscsi.ko" ${PARAMS}
fi
