# Get values in .conf K=V file
# 1 - key
# 2 - file
function _get_conf_kv() {
  grep "${1}" "${2}" | sed "s|^${1}=\"\(.*\)\"$|\1|g"
}

# Replace/add values in .conf K=V file
#
# Args: $1 name, $2 new_val, $3 path
function _set_conf_kv() {
  # Replace
  if grep -q "^$1=" "$3"; then
    sed -i "$3" -e "s\"^$1=.*\"$1=\\\"$2\\\"\""
    return 0
  fi

  # Add if doesn't exist
  echo "$1=\"$2\"" >> $3
}

function dtModel() {
  DEST="/addons/model.dts"
  echo "/dts-v1/;"                                                 > ${DEST}
  echo "/ {"                                                      >> ${DEST}
  echo "    compatible = \"Synology\";"                           >> ${DEST}
  echo "    model = \"${2}\";"                                    >> ${DEST}
  echo "    version = <0x01>;"                                    >> ${DEST}
  # SATA ports
  I=1
  while true; do
    [ ! -d /sys/block/sata${I} ] && break
    PCIEPATH=`cat /sys/block/sata${I}/device/syno_block_info | awk -F'=' '/pciepath/{print$2}'`
    ATAPORT=`cat /sys/block/sata${I}/device/syno_block_info | awk -F'=' '/ata_port_no/{print$2}'`
    echo "    internal_slot@${I} {"                               >> ${DEST}
    echo "        protocol_type = \"sata\";"                      >> ${DEST}
    echo "        ahci {"                                         >> ${DEST}
    echo "            pcie_root = \"${PCIEPATH}\";"               >> ${DEST}
    echo "            ata_port = <0x`printf '%02X' ${ATAPORT}`>;" >> ${DEST}
    echo "        };"                                             >> ${DEST}
    echo "    };"                                                 >> ${DEST}
    I=$((${I}+1))
  done
  NUMPORTS=$((${I}-1))
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/etc/synoinfo.conf"
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/etc.defaults/synoinfo.conf"
  echo "maxdisks=${NUMPORTS}"
  # NVME ports
  I=0
  while true; do
    [ ! -d /sys/block/nvme${I}n1 ] && break
    PCIEROOT=`cat /sys/block/nvme${I}n1/device/syno_block_info | awk -F'=' '/pcie_root/{print$2}'`
    I=$((${I}+1))
    echo "    nvme_slot@${I} {"                                   >> ${DEST}
    echo "        pcie_root = \"${PCIEPATH}\";"                   >> ${DEST}
    echo "        port_type = \"ssdcache\";"                      >> ${DEST}
    echo "    };"                                                 >> ${DEST}
  done
  # USB ports
  COUNT=1
  for I in `ls -d /sys/bus/usb/devices/usb*`; do
    # ROOT
    DCLASS=`cat ${I}/bDeviceClass`
    [ "${DCLASS}" != "09" ] && continue
    SPEED=`cat ${I}/speed`
    [ ${SPEED} -lt 480 ] && continue
    RBUS=`cat ${I}/busnum`
    RCHILDS=`cat ${I}/maxchild`
    HAVE_CHILD=0
    for C in `seq 1 ${RCHILDS}`; do
      SUB="${RBUS}-${C}"
      if [ -d "${I}/${SUB}" ]; then
        DCLASS=`cat ${I}/${SUB}/bDeviceClass`
        [ "${DCLASS}" != "09" ] && continue
        SPEED=`cat ${I}/${SUB}/speed`
        [ ${SPEED} -lt 480 ] && continue
        CHILDS=`cat ${I}/${SUB}/maxchild`
        HAVE_CHILD=1
        for N in `seq 1 ${CHILDS}`; do
          echo "    usb_slot@${COUNT} {"                          >> ${DEST}
          echo "      usb2 {"                                     >> ${DEST}
          echo "        usb_port =\"${RBUS}-${C}.${N}\";"         >> ${DEST}
          echo "      };"                                         >> ${DEST}
          echo "      usb3 {"                                     >> ${DEST}
          echo "        usb_port =\"${RBUS}-${C}.${N}\";"         >> ${DEST}
          echo "      };"                                         >> ${DEST}
          echo "    };"                                           >> ${DEST}
          COUNT=$((${COUNT}+1))
        done
      fi
    done
    if [ ${HAVE_CHILD} -eq 0 ]; then
      for N in `seq 1 ${RCHILDS}`; do
        echo "    usb_slot@${COUNT} {"                            >> ${DEST}
        echo "      usb2 {"                                       >> ${DEST}
        echo "        usb_port =\"${RBUS}-${N}\";"                >> ${DEST}
        echo "      };"                                           >> ${DEST}
        echo "      usb3 {"                                       >> ${DEST}
        echo "        usb_port =\"${RBUS}-${N}\";"                >> ${DEST}
        echo "      };"                                           >> ${DEST}
        echo "    };"                                             >> ${DEST}
        COUNT=$((${COUNT}+1))
      done
    fi
  done
  echo "};"                                                       >> ${DEST}
  dtc -I dts -O dtb ${DEST} > /etc/model.dtb
  cp -fv /etc/model.dtb /run/model.dtb
  /usr/syno/bin/syno_slot_mapping
}

function nondtModel() {
  MAXDISKS=`_get_conf_kv maxdisks /etc/synoinfo.conf`
  echo "Model maxdisks=${MAXDISKS}"
  if [ -z "${2}" ]; then
    # sysfs is populated here
    SCSI_PORTS=`ls /sys/class/scsi_host | wc -w`
    SAS_PORTS=`ls /sys/class/sas_phy | wc -w`
    NUMPORTS=$((${SCSI_PORTS}+${SAS_PORTS}))
    if [ ${MAXDISKS} -gt ${NUMPORTS} ]; then
      NUMPORTS=${MAXDISKS}
    fi
  else
    NUMPORTS="${2}"
  fi
  # Max supported disks is 26
  [ ${NUMPORTS} -gt 26 ] && NUMPORTS=26
  echo "Adjust maxdisks and internalportcfg automatically"
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/etc/synoinfo.conf"
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/etc.defaults/synoinfo.conf"
  INTPORTCFG="0x`printf "%x" "$((2**${NUMPORTS}-1))"`"
  _set_conf_kv "internalportcfg" "${INTPORTCFG}" "/etc/synoinfo.conf"
  _set_conf_kv "internalportcfg" "${INTPORTCFG}" "/etc.defaults/synoinfo.conf"
  # log
  echo "maxdisks=${NUMPORTS}"
  echo "internalportcfg=${INTPORTCFG}"
}

if [ "${1}" = "patches" ]; then

elif [ "${1}" = "late" ]; then

fi
