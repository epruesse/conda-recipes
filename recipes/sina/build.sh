#!/bin/bash

rm $PREFIX/bin/sed

# Get ARBHOME:
ARBHOME=`echo | arb shell | sed -n 's/.*ARBHOME=.\(.*\).$/\1/p'`
export ARBHOME

bash autogen.sh
./configure --prefix=$PREFIX \
	    --disable-dependency-tracking \
	    --disable-silent-rules \
	    --with-sysroot=$PREFIX \
	    --with-arbhome=$ARBHOME ||

bash --norc
make -j$(CPU_COUNT)
make check || true
make install
