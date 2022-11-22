#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing powersched tools"
  cp -vf /usr/sbin/powersched /tmpRoot/usr/sbin/powersched
  chmod 755 /tmpRoot/usr/sbin/powersched
  cat > /tmpRoot/etc/systemd/system/powersched.timer <<'EOF'
[Unit]
Description=Configure RTC to DSM power schedule

[Timer]
OnCalendar=*-*-* *:*:30
Persistent=true

[Install]
WantedBy=timers.target
EOF
  mkdir -p /tmpRoot/etc/systemd/system/timers.target.wants
  ln -sf /etc/systemd/system/powersched.timer /tmpRoot/etc/systemd/system/timers.target.wants/powersched.timer
  cat > /tmpRoot/etc/systemd/system/powersched.service <<'EOF'
[Unit]
Description=Configure RTC to DSM power schedule

[Service]
Type=oneshot
ExecStart=/usr/sbin/powersched

[Install]
WantedBy=multi-user.target
EOF
  mkdir -p /tmpRoot/etc/systemd/system/multi-user.target.wants
  ln -sf /etc/systemd/system/powersched.service /tmpRoot/etc/systemd/system/multi-user.target.wants/powersched.service
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
