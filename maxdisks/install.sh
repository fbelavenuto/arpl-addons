#!/usr/bin/env ash

# Get values in .conf K=V file
# 1 - key
# 2 - file
_get_conf_kv() {
  grep "${1}" "${2}" | sed "s|^${1}=\"\(.*\)\"$|\1|g"
}

# Replace/add values in .conf K=V file
#
# Args: $1 name, $2 new_val, $3 path
_set_conf_kv() {
  # Replace
  if grep -q "^$1=" "$3"; then
    sed -i "$3" -e "s\"^$1=.*\"$1=\\\"$2\\\"\""
    return 0
  fi

  # Add if doesn't exist
  echo "$1=\"$2\"" >> $3
}

if [ "${1}" = "patches" ]; then
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
elif [ "${1}" = "late" ]; then
  echo "Adjust maxdisks and internalportcfg automatically"
  # sysfs is unpopulated here, get the values from ramdisk synoinfo.conf
  NUMPORTS=`_get_conf_kv maxdisks /etc/synoinfo.conf`
  INTPORTCFG=`_get_conf_kv internalportcfg /etc/synoinfo.conf`
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/tmpRoot/etc/synoinfo.conf"
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/tmpRoot/etc.defaults/synoinfo.conf"
  _set_conf_kv "internalportcfg" "${INTPORTCFG}" "/tmpRoot/etc/synoinfo.conf"
  _set_conf_kv "internalportcfg" "${INTPORTCFG}" "/tmpRoot/etc.defaults/synoinfo.conf"
  # log
  echo "maxdisks=${NUMPORTS}"
  echo "internalportcfg=${INTPORTCFG}"
fi
if [ "${1}" = "late" ]; then
  # fix some bugs caused by anothers addons
   sed 's|^destination d_scemd { file("/dev/null"); };|destination d_scemd { file("/var/log/scemd.log"); };|' -i /tmpRoot/etc.defaults/syslog-ng/patterndb.d/scemd.conf
   sed 's|^destination d_synosystemd { file("/dev/null"); };|destination d_synosystemd { file("/var/log/synosystemd.log"); };|' -i /tmpRoot/etc.defaults/syslog-ng/patterndb.d/synosystemd.conf
   sed 's|^destination d_systemd { file("/dev/null"); };|destination d_systemd { file("/var/log/synosystemd.log"); };|' -i /tmpRoot/etc.defaults/syslog-ng/patterndb.d/synosystemd.conf
fi
