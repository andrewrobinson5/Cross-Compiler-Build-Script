#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Supply one parameter: the target to use!!"
  exit 1
fi

if [ -z "${BINUTILS}" ]; then
	BINUTILS="binutils-2.38"
fi
echo "Using ${BINUTILS}"

if [ -z "${GCC}" ]; then
	GCC="gcc-11.4.0"
fi
echo "Using ${GCC}"

echo "Installing dependencies... (root might be needed)"
sudo apt install libgmp3-dev libmpfr-dev libisl-dev libmpc-dev texinfo -y

cd "$(dirname "$0")"

mkdir out
cd out

mkdir path
mkdir src

cd src

wget https://ftp.gnu.org/gnu/binutils/$BINUTILS.tar.xz
wget https://ftp.gnu.org/gnu/gcc/$GCC/$GCC.tar.xz

tar -xvf $BINUTILS.tar.xz
tar -xvf $GCC.tar.xz

export PREFIX="$(pwd)/../path/"
export TARGET=$1
export PATH="$PREFIX/bin:$PATH"

mkdir build-binutils
cd build-binutils
../$BINUTILS/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j $(nproc)
make install

cd ..
mkdir build-gcc
cd build-gcc
../$GCC/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make -j $(nproc) all-gcc
make -j $(nproc) all-target-libgcc
make install-gcc
make install-target-libgcc
