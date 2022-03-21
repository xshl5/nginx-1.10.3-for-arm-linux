# nginx-1.10.3-for-arm-linux

Building for aarch64 ARCH
============
$ aarch64-linux-gnu-gcc --version

aarch64-linux-gnu-gcc (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ export TOOLCHAIN=aarch64-linux-gnu-gcc

$ export PREFIX=/opt/nginx ARCH=aarch64 CROSS_COMPILE=aarch64-linux-gnu-

$ ./build_nginx_arm.sh

For arm32 ARCH
============

$ arm-linux-gnueabihf-gcc --version

arm-linux-gnueabihf-gcc (Ubuntu/Linaro 5.4.0-6ubuntu1~16.04.9) 5.4.0 20160609
Copyright (C) 2015 Free Software Foundation, Inc.
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

$ export TOOLCHAIN=arm-linux-gnueabihf-gcc

$ export PREFIX=/opt/nginx

Unset ARCH, CROSS_COMPILE; and get it from TOOLCHAIN env

$export ARCH= CROSS_COMPILE=

$ ./build_nginx_arm.sh
