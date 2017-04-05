#!/bin/bash
set +x

export ARBHOME=`pwd`
export PATH=$ARBHOME/bin:$PATH
export LD_LIBRARY_PATH=$ARBHOME/lib

export PKG_CONFIG_LIBDIR=$PREFIX/lib/pkgconfig:$PREFIX/share/pkgconfig
export XLIBS=$(pkg-config --libs xpm xerces-c)
export XAW_LIBS=$(pkg-config --libs xaw7)
export XML_INCLUDES=$(pkg-config --cflags xerces-c)
export XINCLUDES=$(pkg-config --cflags x11)

# Suppress building tools bundled with ARB for which we have
# conda packages:
export ARB_BUILD_SKIP_PKGS="MAFFT MUSCLE RAXML PHYLIP FASTTREE"

# ARB stores build settings in config.makefile. Create one from template:
cp config.makefile.template config.makefile

# Now add some target specific settings to config.makefile
case `uname` in
    Linux)
	echo DARWIN := 0
	echo LINUX := 1
	echo MACH := LINUX
	echo LINK_STATIC := 0
	SHARED_LIB_SUFFIX=so
	;;
    Darwin)
	echo DARWIN := 1
	echo LINUX := 0
	echo MACH := DARWIN
	echo LINK_STATIC := 0
	SHARED_LIB_SUFFIX=dylib
	LDFLAGS="$LDFLAGS -Wl,-rpath,$PREFIX/lib"
	CFLAGS="$CLFLAGS -w"
	;;
esac >> config.makefile

echo "PREFIX=$PREFIX"

# make
make SHARED_LIB_SUFFIX=$SHARED_LIB_SUFFIX -j$CPU_COUNT build | sed 's|'$PREFIX'|$PREFIX|g'

# make install
make SHARED_LIB_SUFFIX=$SHARED_LIB_SUFFIX tarfile_quick  | sed 's|'$PREFIX'|$PREFIX|g'

ARB_INST=$PREFIX/lib/arb
mkdir $ARB_INST
tar -C $ARB_INST -xzf arb.tgz
tar -C $ARB_INST -xzf arb-dev.tgz

(cd $PREFIX/bin; ln -s $ARB_INST/bin/arb)

case `uname` in
    Darwin)
	# fix library IDs
	# ARB builds libraries as "-o ../lib/libXYZ.suf". That value becomes the
	# "ID" of the lib and the path searched for by binaries. We need to
	# change all these...

	CHANGE_IDS=""
	ARB_LIBS="$ARB_INST"/lib/*.$SHARED_LIB_SUFFIX
	for lib in $ARB_LIBS; do
	    old_id=`otool -D "$lib" | tail -n 1`
	    new_id="@rpath/${lib##$PREFIX/lib/}"
	    CHANGE_IDS="$CHANGE_IDS -change $old_id $new_id"
	    install_name_tool -id "$new_id" "$lib"
	    echo "Fixing ID of $lib ($old_id => $new_id)"
	done

	ARB_BINS=`find $ARB_INST -type f -perm -a=x | \
	    xargs file | grep Mach-O | cut -d : -f 1 `

	echo "Applying changes to binaries ($ARB_BINS)"
	for bin in $ARB_BINS; do
	    install_name_tool $CHANGE_IDS $bin
	done
	;;
esac
