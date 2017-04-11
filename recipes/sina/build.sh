#!/bin/bash

# Get ARBHOME:
ARBHOME=`echo | arb shell | sed -n 's/.*ARBHOME=.\(.*\).$/\1/p'`

#sh autogen.sh
./configure --prefix=$PREFIX \
	    --disable-dependency-tracking \
	    --disable-silent-rules \
	    --with-sysroot=$PREFIX \
	    --with-boost=$PREFIX \
	    --with-arbhome=$ARBHOME \
            --disable-docs

make -j$(CPU_COUNT)
make check
make install

rm -rf $PREFIX/share/doc/sina
