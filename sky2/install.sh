if [ "${1}" = "rd" ]; then
  echo "Installing module for Marvell Yukon 2 Gigabit Ethernet adapter"
  ${INSMOD} "/modules/sky2.ko" ${PARAMS}
fi
