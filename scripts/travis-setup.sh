#!/bin/bash
set -x 
set -e


case $TRAVIS_OS_NAME in
  linux)
      osname=Linux
      # Install "lynx". ARB build will fail without it.
      sudo apt-get install lynx
      ;;
  *)
      osname=MacOSX
      # Install "lynx". ARB build will fail without it.
      brew install lynx gnu-sed gnu-time
      ;;
esac

curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-$osname-x86_64.sh
sudo bash Miniconda3-latest-$osname-x86_64.sh -b -p /anaconda
sudo chown -R $USER /anaconda
export PATH=/anaconda/bin:$PATH

# reversed order (preferred last)
CHANNELS="epruesse conda-forge defaults r bioconda"

for channel in $CHANNELS; do
    conda config --add channels $channel
done

PACKAGES="
anaconda-client
conda=4.2.13
conda-build
conda-build-all
libtool
"

conda install -y $PACKAGES

#conda index /anaconda/conda-bld/linux-64 /anaconda/conda-bld/osx-64
#conda config --add channels file://anaconda/conda-bld
