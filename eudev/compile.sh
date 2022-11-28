#!/usr/bin/env bash

[ -f all/usr/bin/kmod -a -f all/usr/bin/udevadm ] && exit 0
mkdir all
sudo chown 1000 -R all
docker run --rm -t -v $PWD/src:/input -v $PWD/all:/output fbelavenuto/syno-toolkit:apollolake-7.1 bash /input/docker-compile.sh
sudo chown 1000 -R all
