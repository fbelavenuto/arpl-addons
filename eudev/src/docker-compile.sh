#!/usr/bin/env bash

# test output write allowed before start
mkdir /output/test || exit 1
rmdir /output/test

unset CC
unset LD
unset CFLAGS
unset LDFLAGS
unset LD_LIBRARY_PATH

git clone -c http.sslVerify=false --single-branch https://github.com/kmod-project/kmod.git /tmp/kmod
cd /tmp/kmod
git checkout v30
patch -p1 < /input/kmod.patch
./autogen.sh
./configure --host=x86_64-pc-linux-gnu --prefix=/usr --sysconfdir=/etc --libdir=/usr/lib --enable-tools --disable-manpages --disable-python --without-zstd --without-xz --without-zlib --without-openssl
make all
sudo make install
sudo make DESTDIR=/opt/apollolake/x86_64-pc-linux-gnu/sys-root install
make DESTDIR=/output install
git clone -c http.sslVerify=false --single-branch https://github.com/eudev-project/eudev.git /tmp/eudev
cd /tmp/eudev
git checkout v3.2.11
./autogen.sh
./configure --host=x86_64-pc-linux-gnu --prefix=/usr --sysconfdir=/etc --disable-manpages --disable-selinux --disable-mtd_probe --enable-kmod --disable-blkid
make -i all
sudo make -i install
make -i DESTDIR=/output install
rm -Rf /output/usr/share /output/usr/include /output/usr/lib/pkgconfig /output/usr/lib/libudev.*
rm /output/usr/lib/udev/rules.d/80-net-name-slot.rules
ln -sf /usr/bin/kmod /output/usr/sbin/depmod
chown 1000.1000 -R /output
