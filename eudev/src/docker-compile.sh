#!/usr/bin/env bash

git clone --single-branch https://github.com/kmod-project/kmod.git /tmp/kmod
cd /tmp/kmod
git checkout v30
patch -p1 < /input/kmod.patch
./autogen.sh
./configure CFLAGS='-O2' --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib --enable-tools --disable-manpages --disable-python --without-zstd --without-xz --without-zlib --without-openssl
make all install
make DESTDIR=/output install
git clone --single-branch https://github.com/eudev-project/eudev.git /tmp/eudev
cd /tmp/eudev
git checkout v3.2.11
./autogen.sh
./configure --prefix=/usr --sysconfdir=/etc --enable-static --disable-manpages --disable-selinux --disable-mtd_probe --enable-kmod
make all
make DESTDIR=/output install
rm -Rf /output/usr/share /output/usr/include /output/usr/lib/pkgconfig /output/usr/lib/libudev.*
rm /output/usr/lib/udev/rules.d/80-net-name-slot.rules
