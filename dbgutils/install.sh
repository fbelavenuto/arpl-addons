#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Binaries for debug is available"
  tar -zxvf /addons/acpid.tgz -C /tmpRoot/
fi
