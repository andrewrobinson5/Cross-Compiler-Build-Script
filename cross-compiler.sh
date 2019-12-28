#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Supply one parameter: the target to use!!"
  exit 1
fi

sudo apt install libgmp3-dev libmpfr-dev libisl-dev libcloog-isl-dev libmpc-dev texinfo -y

cd "$(dirname "$0")"

mkdir out
cd out

mkdir path
mkdir src

cd src

wget https://ftp.gnu.org/gnu/binutils/binutils-2.33.1.tar.xz
wget ftp://ftp.gnu.org/gnu/gcc/gcc-9.2.0/gcc-9.2.0.tar.xz

tar -xvf binutils-2.33.1.tar.xz
tar -xvf gcc-9.2.0.tar.xz

export PREFIX="$(pwd)/../path/"
export TARGET=$1
export PATH="$PREFIX/bin:$PATH"

mkdir build-binutils
cd build-binutils
../binutils-2.33.1/configure --target=$TARGET --prefix="$PREFIX" --with-sysroot --disable-nls --disable-werror
make -j $(nproc)
make install

cd ..
mkdir build-gcc
cd build-gcc
../gcc-9.2.0/configure --target=$TARGET --prefix="$PREFIX" --disable-nls --enable-languages=c,c++ --without-headers
make -j $(nproc) all-gcc
make -j $(nproc) all-target-libgcc
make install-gcc
make install-target-libgcc
