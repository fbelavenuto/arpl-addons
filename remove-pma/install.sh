#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
  echo "Installing remove-pma script"
  # Add line to crontab, execute each hour
  echo "0       *       *       *       *       root    /usr/bin/find /volume1/@appstore/SurveillanceStation/local_display/.config/chromium-local-display/BrowserMetrics -name \"*.pma\" -delete" >> /tmpRoot/etc/crontab
fi
