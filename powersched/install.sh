#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing powersched tools"
  cp -vf /usr/sbin/powersched /tmpRoot/usr/sbin/powersched
  chmod 755 /tmpRoot/usr/sbin/powersched
  # Add line to crontab, execute each minute
  if ! grep -q "/usr/sbin/powersched" /tmpRoot/etc/crontab; then
    echo "* * * * * root /usr/sbin/powersched" >> /tmpRoot/etc/crontab
  fi
fi
