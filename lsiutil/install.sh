#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Copying lsiutil to HD"
  cp -vf /usr/sbin/lsiutil /tmpRoot/usr/sbin/lsiutil
fi
