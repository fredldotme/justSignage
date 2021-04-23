#/bin/bash

PROJECT=justSignage
VERSION=0.0.0-rc0
INSTALL=/opt/${PROJECT}-${VERSION}

set -e

SRC_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SRC_PATH

if [ -f /usr/bin/apt ]; then
    bash deps/apt.sh
elif [ -f /usr/bin/dnf ]; then
    bash deps/dnf.sh
fi

function build_3rdparty_autogen {
    cd $SRC_PATH
    cd 3rdparty/$1
    ./autogen.sh
    ./configure --prefix=$INSTALL
    make -j`nproc --all`
    sudo make install
}

function build_3rdparty_cmake {
    echo "Building: $1"
    cd $SRC_PATH
    cd 3rdparty/$1
    if [ -d build ]; then
        rm -rf build
    fi
    mkdir build
    cd build
    PKG_CONFIG_PATH=$INSTALL/lib64/pkgconfig:$INSTALL/lib/pkgconfig cmake .. \
        -DCMAKE_INSTALL_PREFIX=$INSTALL \
        -DCMAKE_MODULE_PATH=$INSTALL \
        -DCMAKE_CXX_FLAGS=-isystem\ $INSTALL/include \
        -DCMAKE_SHARED_LINKER_FLAGS=-L$INSTALL/lib64\ -L/usr/lib64
    make -j`nproc --all`
    sudo make install
}

if [ -d $INSTALL ]; then
    sudo rm -rf $INSTALL
fi

build_3rdparty_cmake properties-cpp
build_3rdparty_cmake process-cpp
build_3rdparty_autogen click
build_3rdparty_cmake lomiri-app-launch
build_3rdparty_cmake qtmir

if [ -d build ]; then
    rm -rf build
fi

cd $SRC_PATH
mkdir build/
cmake ..
make -j`nproc --all`
