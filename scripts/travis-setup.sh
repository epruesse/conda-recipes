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
      export PATH="/usr/local/opt/gnu-sed/libexec/gnubin:$PATH"

            hash -r
      ;;
esac

curl -O https://repo.continuum.io/miniconda/Miniconda3-latest-$osname-x86_64.sh
sudo bash Miniconda3-latest-$osname-x86_64.sh -b -p /anaconda
sudo chown -R $USER /anaconda
export PATH=/anaconda/bin:$PATH

conda update -y -q conda

# reversed order (preferred last)
CHANNELS="defaults r bioconda conda-forge epruesse"

for channel in $CHANNELS; do
    conda config --add channels $channel
done

conda install -y conda-build-all

