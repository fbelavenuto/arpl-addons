#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing daemon for ACPI button"
  tar -zxvf /addons/acpid.tgz -C /tmpRoot/
  chmod 755 /tmpRoot/usr/sbin/acpid
  chmod 644 /tmpRoot/etc/acpi/events/power
  chmod 755 /tmpRoot/etc/acpi/power.sh
  chmod 644 /tmpRoot/usr/lib/systemd/system/acpid.service
  ln -sf /usr/lib/systemd/system/acpid.service /tmpRoot/etc/systemd/system/multi-user.target.wants/acpid.service
fi
