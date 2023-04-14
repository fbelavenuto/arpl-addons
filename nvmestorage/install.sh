#!/usr/bin/env ash

if [ "${1}" = "jrExit" ]; then
  /usr/bin/nvmestorage.sh 2>/dev/null
elif [ "${1}" = "late" ]; then
  echo "Creating service to exec NVMe Storage"
  cp -v /usr/bin/nvmestorage.sh /tmpRoot/usr/bin/nvmestorage.sh
  DEST="/tmpRoot/lib/systemd/system/nvmestorage.service"
  echo "[Unit]"                                                               > ${DEST}
  echo "Description=Enable NVMe storage"                                      >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Service]"                                                            >>${DEST}
  echo "Type=oneshot"                                                         >>${DEST}
  echo "RemainAfterExit=true"                                                 >>${DEST}
  echo "ExecStart=/usr/bin/nvmestorage.sh"                                    >>${DEST}
  echo "ExecStop=/usr/bin/nvmestorage.sh"                                     >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Install]"                                                            >>${DEST}
  echo "WantedBy=multi-user.target"                                           >>${DEST}

  mkdir -p /tmpRoot/etc/systemd/system/multi-user.target.wants
  ln -sf /lib/systemd/system/nvmestorage.service /tmpRoot/lib/systemd/system/multi-user.target.wants/nvmestorage.service
fi
