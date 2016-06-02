# Cross-Compiler-Build-Script
script that builds gcc and binutils nice and easy.

Just place the cross-compiler.sh script in your home directory and launch it from terminal using the following command:

    `./cross-compiler.sh i686-elf`

. Replace i686-elf with your target and you are set. It will do everything. It will create all directories you need, download GCC 6.1.0 and Binutils 2.26 and build them together. It even installs the prerequisites for you. It only works on apt-based systems and has only been tested on ubuntu.

You will also need to run the following command when you want to use the cross-compiler:

    `export PATH="$HOME/opt/cross/bin:$PATH"`
