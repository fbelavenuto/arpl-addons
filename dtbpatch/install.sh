#!/usr/bin/env ash

# Detect correct file
HW_REVISION=`cat /proc/sys/kernel/syno_hw_revision`
[ -n "${HW_REVISION}" ] && DTBFILE="model_${HW_REVISION}.dtb" || DTBFILE="model.dtb"
[ -e /etc.defaults/${DTBFILE} ] || DTBFILE="model.dtb"

if [ "${1}" = "patches" ]; then
  echo "dtbpatch - patches"
  # fix executable flag
  chmod +x /usr/sbin/dtbpatch

  echo "Patching /etc.defaults/${DTBFILE}"

  # Dynamic generation
  if dtbpatch /etc.defaults/${DTBFILE} /var/run/model.dtb; then
    cp -vf /var/run/model.dtb /etc.defaults/${DTBFILE}
  else
    echo "Error patching dtb"
    exit 1
  fi
elif [ "${1}" = "late" ]; then
  echo "dtbpatch - late"
  echo "Copying /etc.defaults/${DTBFILE}"
  # copy file
  cp -vf /etc.defaults/${DTBFILE} /tmpRoot/etc.defaults/model.dtb
  cp -f /usr/sbin/dtc /tmpRoot/usr/bin
fi
