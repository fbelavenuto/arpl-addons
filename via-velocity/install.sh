if [ "${1}" = "rd" ]; then
  echo "Installing module for VIA Networking Velocity Family Gigabit Ethernet Adapter"
  ${INSMOD} "/modules/via-velocity.ko" ${PARAMS}
fi
