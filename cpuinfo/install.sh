#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing daemon for CPU Info"
  tar -xzvf /addons/cpuinfo.tgz -C /tmpRoot/
fi
