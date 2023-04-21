#!/usr/bin/env ash

if [ "${1}" = "jrExit" ]; then
  /usr/bin/cpuinfo.sh 2>/dev/null
elif [ "${1}" = "late" ]; then
  echo "Creating service to exec CPUInfo"
  cp -v /usr/bin/cpuinfo.sh /tmpRoot/usr/bin/cpuinfo.sh
  chmod 755 /tmpRoot/usr/sbin/cpuinfo.sh
  DEST="/tmpRoot/lib/systemd/system/cpuinfo.service"
  echo "[Unit]"                                                               > ${DEST}
  echo "Description=Enable CPUInfo Script"                                    >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Service]"                                                            >>${DEST}
  echo "Type=oneshot"                                                         >>${DEST}
  echo "RemainAfterExit=true"                                                 >>${DEST}
  echo "ExecStart=/usr/bin/cpuinfo.sh"                                        >>${DEST}
  echo "ExecStop=/usr/bin/cpuinfo.sh"                                         >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Install]"                                                            >>${DEST}
  echo "WantedBy=multi-user.target"                                           >>${DEST}

  mkdir -p /tmpRoot/etc/systemd/system/multi-user.target.wants
  ln -sf /lib/systemd/system/cpuinfo.service /tmpRoot/lib/systemd/system/multi-user.target.wants/cpuinfo.service
fi
