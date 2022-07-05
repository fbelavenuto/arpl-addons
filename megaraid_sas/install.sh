if [ "${1}" = "rd" ]; then
  echo "Installing module for Avago MegaRAID SAS adapter"
  ${INSMOD} "/modules/megaraid_sas.ko" ${PARAMS}
fi
