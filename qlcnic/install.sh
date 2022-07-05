if [ "${1}" = "rd" ]; then
  echo "Installing module for QLogic 1/10 GbE Converged/Intelligent Ethernet adapter"
  ${INSMOD} "/modules/qlcnic.ko" ${PARAMS}
fi
