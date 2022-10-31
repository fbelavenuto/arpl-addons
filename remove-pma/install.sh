#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing remove-pma timer/service"
  cat > /tmpRoot/etc/systemd/system/remove-pma.timer <<'EOF'
[Unit]
Description=Timer to remove *.pma files from Surveillance Station (#215 issue)

[Timer]
OnCalendar=*-*-* *:0:0
Persistent=true

[Install]
WantedBy=timers.target
EOF
  mkdir -p /tmpRoot/etc/systemd/system/timers.target.wants
  ln -sf /etc/systemd/system/remove-pma.timer /tmpRoot/etc/systemd/system/timers.target.wants/remove-pma.timer
  cat > /tmpRoot/etc/systemd/system/remove-pma.service <<'EOF'
[Unit]
Description=Service to remove *.pma files from Surveillance Station (#215 issue)

[Service]
Type=oneshot
ExecStart=/usr/bin/find /volume1/@appstore/SurveillanceStation/local_display/.config/chromium-local-display/BrowserMetrics -name "*.pma" -delete

[Install]
WantedBy=multi-user.target
EOF
  mkdir -p /tmpRoot/etc/systemd/system/multi-user.target.wants
  ln -sf /etc/systemd/system/remove-pma.service /tmpRoot/etc/systemd/system/multi-user.target.wants/remove-pma.service
fi
