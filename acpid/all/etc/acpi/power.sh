#!/bin/sh

logger -p err "Shutdown from ACPI"
[ -x /usr/syno/sbin/synopoweroff ] && \
    /usr/syno/sbin/synopoweroff ||
    /usr/sbin/poweroff
