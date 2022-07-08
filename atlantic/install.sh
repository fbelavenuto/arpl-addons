if [ "${1}" = "rd" ]; then
  echo "Installing module for aQuantia AQtion(tm) Ethernet card"
  ${INSMOD} "/modules/atlantic.ko" ${PARAMS}
fi
