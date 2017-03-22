#!/bin/bash
set -e

export ARBHOME=`pwd`
export PATH=$ARBHOME/bin:$PATH

export PKG_CONFIG_LIBDIR=$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig
export XLIBS=$(shell pkg-config --libs xpm xerces-c)
export XAW_LIBS=$(shell pkg-config --libs xaw7)
export XML_INCLUDES=$(shell pkg-config --cflags xerces-c)
export XINCLUDES=$(shell pkg-config --cflags x11)

# Suppress building tools bundled with ARB for which we have
# conda packages:
export ARB_BUILD_SKIP_PKGS="MAFFT MUSCLE RAXML PHYLIP FASTTREE"

if [ -z "$DIRTY" ]; then

    make || true

    case `uname` in
	Linux)
	    echo DARWIN := 0
	    echo LINUX := 1
	    echo MACH := LINUX
	    ;;
	Darwin)
	    echo DARWIN := 1
	    echo LINUX := 0
	    echo MACH := DARWIN
	    ;;
    esac >> config.makefile
fi

make_args="LIBPATH=-Wl,-rpath,$PREFIX/lib -L$ARBHOME/lib"
no_mafftlinks="MAFFTLINKS="

make "$make_args" $no_mafftlinks -j$CPU_COUNT build
make "$make_args" $no_mafftlinks -j1 build
make "$make_args" $no_mafftlinks tarfile_quick

mkdir $PREFIX/lib/arb
tar -C $PREFIX/lib/arb -xzf arb.tgz
tar -C $PREFIX/lib/arb -xzf arb-dev.tgz

cd $PREFIX/bin
ln -s $PREFIX/lib/arb/bin/arb

