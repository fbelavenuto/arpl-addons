#!/usr/bin/env bash

set -e

mkdir -p all/usr/sbin
make -C src clean all
cp src/dtbpatch all/usr/sbin
