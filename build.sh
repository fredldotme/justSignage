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
    echo "Building: $1"
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
    PKG_CONF_SYSTEM=/usr/lib/x86_64-linux-gnu/pkgconfig
    PKG_CONF_INSTALL=$INSTALL/lib/pkgconfig:$INSTALL/lib/x86_64-linux-gnu/pkgconfig
    PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PKG_CONF_SYSTEM:$PKG_CONF_INSTALL
    env PKG_CONFIG_PATH=$PKG_CONFIG_PATH LDFLAGS="-L$INSTALL/lib" \
    	cmake .. \
        -DCMAKE_INSTALL_PREFIX=$INSTALL \
        -DCMAKE_MODULE_PATH=$INSTALL \
        -DCMAKE_CXX_FLAGS="-isystem $INSTALL/include -L$INSTALL/lib -Wno-deprecated-declarations -Wl,-rpath-link,$INSTALL/lib" \
        -DCMAKE_C_FLAGS="-isystem $INSTALL/include -L$INSTALL/lib -Wno-deprecated-declarations -Wl,-rpath-link,$INSTALL/lib" \
        -DCMAKE_LD_FLAGS="-L$INSTALL/lib" \
        -DCMAKE_LIBRARY_PATH=$INSTALL/lib
    make VERBOSE=1 -j`nproc --all`
    sudo make install
}

if [ -d $INSTALL ]; then
    sudo rm -rf $INSTALL
fi

# Build these deps on non-apt systems
if [ ! -f /usr/bin/apt ]; then
    build_3rdparty_cmake properties-cpp
    build_3rdparty_cmake process-cpp
fi

build_3rdparty_autogen click
build_3rdparty_cmake lomiri-api
build_3rdparty_cmake lomiri-app-launch
build_3rdparty_cmake lomiri-url-dispatcher
build_3rdparty_cmake qtmir

cd $SRC_PATH
cd src
if [ -d build ]; then
    rm -rf build
fi
mkdir build/
cmake ..
make -j`nproc --all`
