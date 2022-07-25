#!/usr/bin/env ash

if [ "${1}" = "early" ]; then
  echo "Loading 9p module"
  modprobe 9p
  modprobe 9pnet_virtio
fi
