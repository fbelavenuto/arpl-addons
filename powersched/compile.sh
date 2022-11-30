#!/usr/bin/env bash

set -e

[ -f all/usr/sbin/powersched ] && exit 0

mkdir -p all/usr/sbin
make -C src clean all
cp src/powersched all/usr/sbin
