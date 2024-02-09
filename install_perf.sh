#!/bin/bash

# Install the `perf` from Linux kernel source.
# The `perf` is set of tools for Linux allows you to profile and drill down
# into the performance of many subsystems of the kernel. This script also works
# inside a Codespace.
#
# See https://man7.org/linux/man-pages/man1/perf.1.html for more info.
# See https://www.brendangregg.com/perf.html for introduction and examples.

set -e;

# Install dependencies
sudo apt update
sudo apt install -y bc bison libbabeltrace-ctf-dev libtrace-dev libperl-dev libnuma-dev libzstd-dev libunwind-dev libslang2-dev libdw-dev libcap-dev systemtap-sdt-dev clang flex git gcc libclang-dev libelf-dev lld llvm-dev libncurses-dev make qemu-system-x86 libpfm4-dev python3-dev python3-setuptools pkg-config binutils-dev

WORK_DIR=/tmp/install-perf-script
sudo rm -rf $WORK_DIR
mkdir $WORK_DIR

# install `libtraceevent` (see https://github.com/rostedt/libtraceevent for more info)
LIBTRACE_FOLDER_NAME=libtraceevent
git clone https://git.kernel.org/pub/scm/libs/libtrace/libtraceevent.git $WORK_DIR/$LIBTRACE_FOLDER_NAME
make -C $WORK_DIR/$LIBTRACE_FOLDER_NAME
sudo make install -C $WORK_DIR/$LIBTRACE_FOLDER_NAME

# build & install the `perf` tool
LINUX_FOLDER_NAME=linux
git clone --depth 1 https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git $WORK_DIR/$LINUX_FOLDER_NAME
make -j$(nproc) -C $WORK_DIR/$LINUX_FOLDER_NAME/tools/perf
# copy the binary to usr/bin
sudo cp $WORK_DIR/$LINUX_FOLDER_NAME/tools/perf/perf /usr/bin

# check that the `perf` is installed
perf -v

# try `sudo perf stat sleep 1` now!
echo 'The `perf` is installed successfully! Run `sudo perf stat sleep 1` to try it out now.'
