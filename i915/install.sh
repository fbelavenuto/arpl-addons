#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Copying 10th Gen iGPU firmware and drivers"
  tar -zxvf /addons/i915.tgz -C /tmpRoot/
  chmod 755 /tmpRoot/usr/lib/firmware/i915/*.bin
fi
