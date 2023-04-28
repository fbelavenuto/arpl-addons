#!/usr/bin/env ash

if [ "${1}" = "late" ]; then
echo "Insert RebootToArc Task"
sqlite3 /tmpRoot/usr/syno/etc/esynoscheduler/esynoscheduler.db <<EOF
INSERT INTO task VALUES('RebootToArc', '', 'shutdown', '', 0, 0, 0, 0, '', 0, 'echo 1 > /proc/sys/kernel/syno_install_flag
[ -b /dev/synoboot1 ] && (mkdir -p /tmp/synoboot1; mount /dev/synoboot1 /tmp/synoboot1)
[ -f /tmp/synoboot1/grub/grubenv ] && grub-editenv /tmp/synoboot1/grub/grubenv set next_entry=config
reboot', 'script', '{}', '', '', '{}', '{}');
EOF
fi