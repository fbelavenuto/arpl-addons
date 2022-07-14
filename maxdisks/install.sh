#!/usr/bin/env ash

if [ "${1}" != "patches" -a "${1}" != "late" ]; then
  return
fi

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

echo "Adjust maxdisks and internalportcfg automatically"
if [ "${1}" = "patches" ]; then
  # sysfs is populated here
  NUMPORTS=`ls /sys/class/scsi_host | wc -w`
  # Max supported disks is 26
  [ ${NUMPORTS} -gt 26 ] && NUMPORTS=26
  INTPORTCFG="0x`printf "%x" "$((2**${NUMPORTS}-1))"`"
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/etc/synoinfo.conf"
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/etc.defaults/synoinfo.conf"
  _set_conf_kv "internalportcfg" "${INTPORTCFG}" "/etc/synoinfo.conf"
  _set_conf_kv "internalportcfg" "${INTPORTCFG}" "/etc.defaults/synoinfo.conf"
elif [ "${1}" = "late" ]; then
  # sysfs is unpopulated here, get the values from ramdisk synoinfo.conf
  NUMPORTS=`_get_conf_kv maxdisks /etc/synoinfo.conf`
  INTPORTCFG=`_get_conf_kv internalportcfg /etc/synoinfo.conf`
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/tmpRoot/etc/synoinfo.conf"
  _set_conf_kv "maxdisks" "${NUMPORTS}" "/tmpRoot/etc.defaults/synoinfo.conf"
  _set_conf_kv "internalportcfg" "${INTPORTCFG}" "/tmpRoot/etc/synoinfo.conf"
  _set_conf_kv "internalportcfg" "${INTPORTCFG}" "/tmpRoot/etc.defaults/synoinfo.conf"
fi
# log
echo "maxdisks=${NUMPORTS}"
echo "internalportcfg=${INTPORTCFG}"
