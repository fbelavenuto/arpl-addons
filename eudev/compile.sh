#!/usr/bin/env bash

#[ -f all/usr/bin/kmod -a -f all/usr/bin/udevadm ] && exit 0
docker run -u 1000 --rm -t -v $PWD/src:/input -v $PWD/all:/output fbelavenuto/syno-compiler bash /input/docker-compile.sh
sudo chown `id -u`:`id -g` -R all
