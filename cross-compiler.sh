#!/bin/bash

if [ "$#" -ne 1 ]; then
  echo "Supply one parameter: the target to use!!"
  exit 1
fi

is_command() {
    # Checks for existence of string passed in as only function argument.
    # Exit value of 0 when exists, 1 if not exists. Value is the result
    # of the `command` shell built-in call.
    local check_command="$1"

    command -v "${check_command}" >/dev/null 2>&1
}

# Compatibility
distro_check() {
# If apt-get is installed, then we know it's part of the Debian family
if is_command apt-get ; then
    # Set some global variables here
    # We don't set them earlier since the family might be Red Hat, so these values would be different
    PKG_MANAGER="apt-get"
    # A variable to store the command used to update the package cache
    UPDATE_PKG_CACHE="${PKG_MANAGER} update"
    # An array for installing packages
    PKG_INSTALL=(${PKG_MANAGER} --yes --no-install-recommends install)
    # Dependencies for building the cross-compiler
    DEPS=(build-essential bison flex libgmp3-dev libmpfr-dev libisl-dev libcloog-isl-dev libmpc-dev texinfo)
# If apt-get is not found, check for rpm to see if it's a Red Hat family OS
elif is_command rpm ; then
    # Then check if dnf or yum is the package manager
    if is_command dnf ; then
        PKG_MANAGER="dnf"
    else
        PKG_MANAGER="yum"
    fi

    # Fedora and family update cache on every PKG_INSTALL call, no need for a separate update.
    UPDATE_PKG_CACHE=":"
    PKG_INSTALL=(${PKG_MANAGER} install -y)
    DEPS=(gcc gcc-c++ make bison flex gmp-devel libmpc-devel mpfr-devel texinfo)
else
  printf "OS not supported\n"
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
