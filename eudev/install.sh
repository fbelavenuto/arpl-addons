#!/usr/bin/env ash

if [ "${1}" = "modules" ]; then
  echo "Starting eudev daemon"
  [ -e /proc/sys/kernel/hotplug ] && printf '\000\000\000\000' > /proc/sys/kernel/hotplug
  /sbin/udevd -d || { echo "FAIL"; exit 1; }
  echo "Triggering add events to udev"
  udevadm trigger --type=subsystems --action=add
  udevadm trigger --type=devices --action=add
  udevadm settle --timeout=30 || echo "udevadm settle failed"
  # Give more time
  sleep 10
  # Remove from memory to not conflict with RAID mount scripts
  /usr/bin/killall udevd
  sleep 10
  /sbin/udevd -d
  echo "Triggering add events to udev, again"
  udevadm trigger --type=subsystems --action=add
  udevadm trigger --type=devices --action=add
  udevadm settle --timeout=30 || echo "udevadm settle failed"
  # Give more time
  sleep 10
  # Remove from memory to not conflict with RAID mount scripts
  /usr/bin/killall udevd
fi
