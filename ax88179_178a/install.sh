if [ "${1}" = "rd" ]; then
  echo "Installing module for ASIX AX88179/178A based USB 3.0/2.0 Gigabit Ethernet"
  ${INSMOD} "/modules/ax88179_178a.ko" ${PARAMS}
fi
