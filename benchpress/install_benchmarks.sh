#!/bin/bash
# Downloads and compiles schbench and fio, putting the binaries into ./benchmarks/

# benchmark binaries that we install here live in benchmarks/
BENCHMARKS_DIR="$(pwd)/benchmarks"
mkdir -p benchmarks

rm -rf build
mkdir -p build
pushd build

# make schbench
git clone https://kernel.googlesource.com/pub/scm/linux/kernel/git/mason/schbench
pushd schbench
make
# move the binary to the install dir
mv schbench $BENCHMARKS_DIR
popd

# make fio

# this is a kinda hacky way to ensure that libaio is installed
echo "#include <libaio.h>" | gcc -c -x c -o /dev/null - 2> /dev/null
if [ $? -ne 0 ]; then
  echo "libaio development headers are not installed, please install them and rerun this script"
  exit 1
fi

git clone http://git.kernel.dk/fio.git
pushd fio
make
# move the binary to the install dir
mv fio $BENCHMARKS_DIR
popd

# destroy the build directory
popd
rm -rf build

echo "Benchmarks installed into ./benchmarks/"
