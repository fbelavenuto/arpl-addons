#!/usr/bin/env ash

SED_PATH='/tmpRoot/usr/bin/sed'

if [ "${1}" = "modules" ]; then
  echo "Loading FB and console modules..."
  if [ -n "${2}" ]; then
    /usr/sbin/modprobe ${2}
  else
    for M in i915 efifb vesafb vga16fb; do
      [ -e /sys/class/graphics/fb0 ] && break
      /usr/sbin/modprobe ${M}
    done
  fi
  /usr/sbin/modprobe fbcon
  echo "ARPL console - wait..." > /dev/tty1
  # Workaround for DVA1622
  if [ "${MODEL}" = "DVA1622" ]; then
    echo > /dev/tty2
    /usr/bin/ioctl /dev/tty0 22022 -v 2
    /usr/bin/ioctl /dev/tty0 22022 -v 1
  fi
elif [ "${1}" = "rcExit" ]; then
  # Run only in junior mode (DSM not installed)
  echo -e "Junior mode\n" > /etc/issue
  echo "Starting getty..."
  /usr/sbin/getty -L 0 tty1 &
  /usr/bin/loadkeys /usr/share/keymaps/i386/${LAYOUT}/${KEYMAP}.map.gz
  # Workaround for DVA1622
  if [ "${MODEL}" = "DVA1622" ]; then
    echo > /dev/tty2
    /usr/bin/ioctl /dev/tty0 22022 -v 2
    /usr/bin/ioctl /dev/tty0 22022 -v 1
  fi
elif [ "${1}" = "late" ]; then
  # run when boot installed DSM
  cp -fv /tmpRoot/lib/systemd/system/serial-getty\@.service /tmpRoot/lib/systemd/system/getty\@.service
  ${SED_PATH} -i 's|^ExecStart=.*|ExecStart=-/sbin/agetty %I 115200 linux|' /tmpRoot/lib/systemd/system/getty\@.service
  mkdir -vp /tmpRoot/lib/systemd/system/getty.target.wants
  ln -sfv /lib/systemd/system/getty\@.service /tmpRoot/lib/systemd/system/getty.target.wants/getty\@tty1.service
  echo -e "DSM mode\n" > /tmpRoot/etc/issue
  cp -fRv /usr/share/keymaps /tmpRoot/usr/share/
  cp -fv /usr/bin/loadkeys /tmpRoot/usr/bin/
  cp -fv /usr/bin/setleds /tmpRoot/usr/bin/
  DEST="/tmpRoot/lib/systemd/system/keymap.service"
  echo "[Unit]"                                                               > ${DEST}
  echo "Description=Configure keymap"                                         >>${DEST}
  echo "After=getty.target"                                                   >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Service]"                                                            >>${DEST}
  echo "Type=oneshot"                                                         >>${DEST}
  echo "RemainAfterExit=true"                                                 >>${DEST}
  echo "ExecStart=/usr/bin/loadkeys /usr/share/keymaps/i386/${LAYOUT}/${KEYMAP}.map.gz" >>${DEST}
  echo                                                                        >>${DEST}
  echo "[Install]"                                                            >>${DEST}
  echo "WantedBy=multi-user.target"                                           >>${DEST}

  mkdir -p /tmpRoot/etc/systemd/system/multi-user.target.wants
  ln -sf /lib/systemd/system/keymap.service /tmpRoot/lib/systemd/system/multi-user.target.wants/keymap.service
  # Workaround for DVA1622
  if [ "${MODEL}" = "DVA1622" ]; then
    echo > /dev/tty2
    /usr/bin/ioctl /dev/tty0 22022 -v 2
    /usr/bin/ioctl /dev/tty0 22022 -v 1
  fi
fi
