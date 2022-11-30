#!/usr/bin/env bash

set -e

[ -f all/usr/sbin/dtbpatch ] && exit 0

mkdir -p all/usr/sbin
make -C src clean all
cp src/dtbpatch all/usr/sbin
