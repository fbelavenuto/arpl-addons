#!/usr/bin/env ash

if [ `mount | grep tmpRoot | wc -l` -gt 0 ] ; then

SED_PATH='/tmpRoot/usr/bin/sed'

if [ "${1}" = "late" ]; then
  echo "Installing powersched tools"
  cp -vf /usr/sbin/powersched /tmpRoot/usr/sbin/powersched
  chmod 755 /tmpRoot/usr/sbin/powersched
  # Clean old entries
  ${SED_PATH} -i '/\/usr\/sbin\/powersched/d' /tmpRoot/etc/crontab 
  # Add line to crontab, execute each minute
  echo "*       *       *       *       *       root    /usr/sbin/powersched #arpl powersched addon" >> /tmpRoot/etc/crontab
fi
