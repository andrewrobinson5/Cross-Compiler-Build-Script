# Cross-Compiler-Build-Script
script that builds gcc and binutils nice and easy.

Just place the cross-compiler.sh script in your home directory and launch it from terminal using the following command:

    ./cross-compiler.sh x86_64-elf

If you want to set a specific version of gcc or binutils, use the BINUTILS and GCC environment variables:

    GCC=gcc-13.2.0 BINUTILS=binutils-2.42 ./cross-compiler.sh x86_64-elf

Replace x86_64-elf with your target and you are set. It will do everything. It will create all directories you need, download GCC 11.4.0 and Binutils 2.38 and build them together. It even installs the prerequisites for you. It only works on apt-based systems and has only been tested on Ubuntu.

You will also need to run something like the following command when you want to use the cross-compiler:

    . activate.sh

Some common triples include:
 - i686-elf
 - x86_64-elf
 - arm-none-eabi
 - aarch64-none-elf
 - riscv64-none-elf
 
Read more about Target Triplets at [Target Triplets](https://wiki.osdev.org/Target_Triplet).
