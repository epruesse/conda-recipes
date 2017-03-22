#!/bin/bash
set -x 
set -e

case $TRAVIS_OS_NAME in
  linux)
    osname=Linux
  ;;
  *)
    osname=MacOSX
esac

curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-$osname-x86_64.sh
sudo bash Miniconda3-latest-$osname-x86_64.sh -b -p /anaconda
sudo chown -R $USER /anaconda
export PATH=/anaconda/bin:$PATH

# reversed order (preferred last)
CHANNELS="conda-forge defaults r bioconda"

for channel in $CHANNELS; do
    conda config --add channels $channel
done

PACKAGES="
anaconda-client
conda
conda-build
"

conda index /anaconda/conda-bld/linux-64 /anaconda/conda-bld/osx-64
conda config --add channels file://anaconda/conda-bld
