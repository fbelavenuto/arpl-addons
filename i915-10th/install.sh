#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing 10th Gen iGPU firmware and drivers"
  tar -zxvf /addons/i915.tgz -C /tmpRoot/
fi
