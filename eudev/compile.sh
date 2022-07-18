#!/usr/bin/env bash

sudo chown `id -u`:`id -g` -R all
[ -f all/usr/bin/kmod -a -f all/usr/bin/udevadm ] && exit 0
docker run --rm -t -v $PWD/src:/input -v $PWD/all:/output fbelavenuto/syno-compiler bash /input/docker-compile.sh
