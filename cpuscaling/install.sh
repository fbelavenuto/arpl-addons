#!/usr/bin/env ash

if [ "${1}" = "jrExit" ]; then
  /usr/bin/cpuscaling.sh 2>/dev/null
elif [ "${1}" = "late" ]; then
  echo "Creating service to exec CPUScaling"
  cp -v /usr/bin/cpuscaling.sh /tmpRoot/usr/bin/cpuscaling.sh
  chmod 755 /tmpRoot/usr/sbin/cpuscaling.sh
  DEST="/tmpRoot/lib/systemd/system/cpuscaling.service"
  echo "[Unit]"                                                               > ${DEST}
  echo "Description=Enable CPUScaling Script"                                 >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Service]"                                                            >>${DEST}
  echo "Restart=on-abnormal"                                                  >>${DEST}
  echo "ExecStart=/usr/bin/cpuscaling.sh"                                     >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Install]"                                                            >>${DEST}
  echo "WantedBy=multi-user.target"                                           >>${DEST}

  mkdir -p /tmpRoot/etc/systemd/system/multi-user.target.wants
  ln -sf /lib/systemd/system/cpuscaling.service /tmpRoot/lib/systemd/system/multi-user.target.wants/cpuscaling.service
fi
