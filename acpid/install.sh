#!/usr/bin/env ash

#if [ "${1}" = "early" ]; then
  #/usr/sbin/acpid
#el
if [ "${1}" = "late" ]; then
  #/usr/bin/killall acpid
  echo "Installing daemon for ACPI button"
  cp -v /usr/sbin/acpid /tmpRoot/usr/sbin/acpid
  mkdir -p /tmpRoot/etc/acpi/events/
  cp -v /etc/acpi/events/power /tmpRoot/etc/acpi/events/power
  cp -v /etc/acpi/power.sh /tmpRoot/etc/acpi/power.sh
  cp -v /usr/lib/systemd/system/acpid.service /tmpRoot/usr/lib/systemd/system/acpid.service
  mkdir -vp /tmpRoot/lib/systemd/system/multi-user.target.wants
  ln -vsf /usr/lib/systemd/system/acpid.service /tmpRoot/lib/systemd/system/multi-user.target.wants/acpid.service
fi
