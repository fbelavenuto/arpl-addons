if [ "${1}" = "rd" ]; then
  echo "Installing module for VMware vmxnet3 virtual NIC adapter"
  ${INSMOD} "/modules/vmxnet3.ko" ${PARAMS}
fi
