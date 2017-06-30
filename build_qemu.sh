#!/bin/bash
set +e
: '
Licensed under the Apache License, Version 2.0 (the “License”);
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an “AS IS” BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
'

# Install Qemu dependencies for build
sudo yum install -y git zlib.x86_64 glibc-devel.x86_64 zlib-devel.x86_64 \
pixman-devel.x86_64 libfdt-devel.x86_64 glib2-devel.x86_64

# Clone Qemu Source Code in the same location where
# this script was executed.
git clone https://github.com/qemu/qemu.git

# Go to qemu source code dir
cd ./qemu

# Creates a location for the build and moves inside it
mkdir -p bin/debug/native
cd bin/debug/native

# Configure Qemu to build only the user-mode for Power
../../../configure --disable-debug-tcg --enable-tcg-interpreter \
--target-list="ppc64abi32-linux-user ppc64le-linux-user ppc64-linux-user" \
--disable-vnc --extra-cflags="-O3"

# Build Qemu
make -j$(nproc)

# Creates a directory to store the build results
mkdir ../../../../build-results

# Copy the build result to the aforementioned location
cp ./ppc64abi32-linux-user/qemu-ppc64abi32 ../../../../build-results
cp ./ppc64le-linux-user/qemu-ppc64le ../../../../build-results
cp ./ppc64-linux-user/qemu-ppc64 ../../../../build-results

# Display build results
cd ../../../../build-results && pwd && ls

# About SDK Integration
echo
echo "SDK expects QEMU binaries at /opt/ibm/qemu-user-space-emulator."
echo "Create the directory using the following command:"
echo "      $sudo mkdir -p /opt/ibm/qemu-user-space-emulator"
echo "Copy the binaries from build-results to /opt/ibm/qemu-user-space-emulator:"
echo "      $sudo cp /build-results/* /opt/ibm/qemu-user-space-emulator"
