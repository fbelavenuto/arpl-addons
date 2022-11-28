#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing powersched tools"
  cp -vf /usr/sbin/powersched /tmpRoot/usr/sbin/powersched
  chmod 755 /tmpRoot/usr/sbin/powersched
  # Add line to crontab, execute each minute
  echo "*       *       *       *       *       root    /usr/sbin/powersched" >> /tmpRoot/etc/crontab
  # Reduce the systemd log level
  if grep -q "^LogLevel=" /tmpRoot/etc/systemd/system.conf; then
    sed 's\^LogLevel=.*\LogLevel=notice' -i /tmpRoot/etc/systemd/system.conf
  else
    echo "LogLevel=notice" >> /tmpRoot/etc/systemd/system.conf
  fi
  for path in /tmpRoot/etc.defaults /tmpRoot/etc
  do
    sed 's|destination(d_scemd);|flags(final);|'       -i ${path}/syslog-ng/patterndb.d/scemd.conf
    sed 's|destination(d_synosystemd);|flags(final);|' -i ${path}/syslog-ng/patterndb.d/synosystemd.conf
    sed 's|destination(d_systemd);|flags(final);|'     -i ${path}/syslog-ng/patterndb.d/synosystemd.conf
  done
fi
