#!/bin/sh

case `uname` in
    Darwin)
	export LDFLAGS="$LDFLAGS -Wl,-rpath,$PREFIX/lib"
	;;
    Linux)
	export LDFLAGS="-L$PREFIX/lib -liconv"
	;;
esac

./configure --prefix=$PREFIX \
            --disable-dependency-tracking \
            --disable-silent-rules \
	    --x-includes=$PREFIX/include \
	    --x-libraries=$PREFIX/include \
	    --enable-jpeg \
	    --enable-png \
	    --enable-xft

echo "PREFIX=$PREFIX"

make -j${CPU_COUNT} | sed 's|'$PREFIX'|$PREFIX|g'
make install
