if [ "${1}" = "rd" ]; then
  echo "Installing module for Intel(R) Ethernet Connection XL710 adapter"
  ${INSMOD} "/modules/i40e.ko" ${PARAMS}
fi
