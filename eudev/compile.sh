#!/usr/bin/env bash

[ -f all/usr/bin/kmod -a -f all/usr/bin/udevadm ] && exit 0
mkdir all
sudo chown 1000 -R all
TOOLKIT_VER="7.1"
#docker run --rm -t -v $PWD/src:/input -v $PWD/all:/output fbelavenuto/syno-toolkit:apollolake-7.1 shell /input/docker-compile.sh
docker run --rm -t -v $PWD/src:/input -v $PWD/all:/output fbelavenuto/syno-compiler:${TOOLKIT_VER} shell apollolake /input/docker-compile.sh
sudo chown 1000 -R all
