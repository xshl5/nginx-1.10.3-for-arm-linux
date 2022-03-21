#!/bin/bash

#TOOLCHAIN=aarch64-linux-gnu-gcc

echo $TOOLCHAIN
$TOOLCHAIN -v
if [ "$TOOLCHAIN" = "" ] || ! $TOOLCHAIN -v >/dev/null 2>&1; then
	echo -e "TOOLCHAIN env not set or invalid.\n"
	exit 1
fi

[ "$PREFIX" = "" ] && PREFIX=/data/nginx
./configure --with-cc="$TOOLCHAIN --static" --add-module=./nginx-rtmp-module --with-pcre=./pcre-8.45 --with-openssl=./openssl-1.1.1i --with-zlib=./zlib-1.2.11 --prefix=$PREFIX

[ "$ARCH" = "" ] && ARCH=${TOOLCHAIN%%'-'*}
[ "$CROSS_COMPILE" = "" ] && CROSS_COMPILE="${TOOLCHAIN%'-'*}"-

#'./config --prefix=/home/xshl5/disk_5/workspace/rtmp/nginx-1.10.3/../openssl-1.1.1i/.openssl no-shared' =>
#'CROSS_COMPILE=aarch64-linux-gnu- ./Configure --prefix=/home/xshl5/disk_5/workspace/rtmp/nginx-1.10.3/../openssl-1.1.1i/.openssl no-shared linux-aarch64'
sed -i 's/.\/config /CROSS_COMPILE='"$CROSS_COMPILE"' .\/Configure /g' objs/Makefile
[ "$ARCH" = "arm" ] && ARCH=armv4
sed -i 's/openssl no-shared/openssl no-shared 'linux-"$ARCH"'/g' objs/Makefile

#'LINK =        $(CC)' => 'LINK =  $(word 1, $(CC))'
LINK_ASSIGN_LINE=$(grep -nr "LINK =" objs/Makefile) && LINE_NUM=$(echo $LINK_ASSIGN_LINE | awk '{print $1*1}')
if [ "$LINE_NUM" != "" ] && [ $LINE_NUM -gt 0 ]; then
	sed -i "$LINE_NUM"d objs/Makefile
	sed -i "$LINE_NUM"i'LINK =  $(word 1, $(CC))' objs/Makefile
else
	echo "Warning: CANNOT found 'LINK =' line, Maybe something wrong!!!"
fi

# Added '-lpthread' link param follow libcrypto.a
sed -i 's/libcrypto.a/libcrypto.a -lpthread/g' objs/Makefile

make -j5
[ $? -eq 0 ] && ("$CROSS_COMPILE"-strip objs/nginx; make install)

