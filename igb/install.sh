if [ "${1}" = "rd" ]; then
  echo "Installing module for Intel(R) 82575 PCI-Express ethernet adapter"
  ${INSMOD} "/modules/igb.ko" ${PARAMS}
fi
