#/bin/bash

set -e

SRC_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SRC_PATH

source common.sh

if [ "$SNAPCRAFT_PART_INSTALL" != "" ]; then
    INSTALL=$SNAPCRAFT_PART_INSTALL/opt/${PROJECT}
elif [ "$INSTALL_DIR" != "" ]; then
    INSTALL=$INSTALL_DIR
else
    INSTALL=/opt/${PROJECT}-${VERSION}
fi

# Internal variables
CLEAN=0
BUILD_DEPS=0
SUB_PROJECTS="all"
UBUNTU_TOUCH=0

# Overridable number of build processors
if [ "$NUM_PROC" == "" ]; then
    NUM_PROCS=$(nproc --all)
fi

# Argument parsing
while [[ $# -gt 0 ]]; do
    arg="$1"
    case $arg in
        -c|--clean)
            CLEAN=1
            shift
        ;;
        -d|--deps)
            BUILD_DEPS=1
            shift
        ;;
        "-s="*|"--subprojects="*)
            SUB_PROJECTS="${arg#*=}"
            shift
        ;;
        -t|--touch)
            UBUNTU_TOUCH=1
            shift
        ;;
        *)
            echo "usage: $0 [-d|--deps] [-c|--clean] [-s=<..,..>|--subprojects=<..,..>] [-t|--touch]"
            exit 1
        ;;
    esac
done

function build_3rdparty_autogen {
    echo "Building: $1"
    cd $SRC_PATH
    cd 3rdparty/$1
    ./autogen.sh
    ./configure --prefix=$INSTALL
    make -j$NUM_PROCS
    if [ -f /usr/bin/sudo ]; then
        sudo make install
    else
        make install
    fi
}

function build_cmake {
    if [ "$CLEAN" == "1" ]; then
        if [ -d build ]; then
            rm -rf build
        fi
    fi
    if [ ! -d build ]; then
        mkdir build
    fi
    cd build
    if [ -f /usr/bin/dpkg-architecture ]; then
        MULTIARCH=$(/usr/bin/dpkg-architecture -qDEB_TARGET_MULTIARCH)
    else
        MULTIARCH=""
    fi
    PKG_CONF_SYSTEM=/usr/lib/$MULTIARCH/pkgconfig
    PKG_CONF_INSTALL=$INSTALL/lib/pkgconfig:$INSTALL/lib/$MULTIARCH/pkgconfig
    PKG_CONFIG_PATH=$PKG_CONFIG_PATH:$PKG_CONF_SYSTEM:$PKG_CONF_INSTALL
    env PKG_CONFIG_PATH=$PKG_CONFIG_PATH LDFLAGS="-L$INSTALL/lib" \
    	cmake .. \
        -DCMAKE_INSTALL_PREFIX=$INSTALL \
        -DCMAKE_MODULE_PATH=$INSTALL \
        -DCMAKE_CXX_FLAGS="-isystem $INSTALL/include -isystem $INSTALL/include/qtmir -L$INSTALL/lib -Wno-deprecated-declarations -Wl,-rpath-link,$INSTALL/lib" \
        -DCMAKE_C_FLAGS="-isystem $INSTALL/include -isystem $INSTALL/include/qtmir -L$INSTALL/lib -Wno-deprecated-declarations -Wl,-rpath-link,$INSTALL/lib" \
        -DCMAKE_LD_FLAGS="-L$INSTALL/lib" \
        -DCMAKE_LIBRARY_PATH=$INSTALL/lib $@
    make VERBOSE=1 -j$NUM_PROCS
    if [ -f /usr/bin/sudo ]; then
        sudo make install
    else
        make install
    fi
}

function build_3rdparty_cmake {
    echo "Building: $1"
    cd $SRC_PATH
    cd 3rdparty/$1
    build_cmake $2
}

function build_project {
    echo "Building project"
    cd $SRC_PATH
    cd src
    build_cmake $1
}

# Install distro-provided dependencies
if [ -f /usr/bin/apt ] && [ -f /usr/bin/sudo ]; then
    bash deps/apt.sh
elif [ -f /usr/bin/dnf ] && [ -f /usr/bin/sudo ]; then
    bash deps/dnf.sh
fi

# Build direct dependencies if requested
if [ "$BUILD_DEPS" == "1" ]; then
    # Build these deps on non-apt systems
    if [ ! -f /usr/bin/apt ]; then
        build_3rdparty_cmake properties-cpp
        build_3rdparty_cmake process-cpp
    fi

    # Build direct dependencies
    if [ "$UBUNTU_TOUCH" == "0" ]; then
        build_3rdparty_autogen click
        build_3rdparty_cmake lomiri-api
        build_3rdparty_cmake lomiri-app-launch
        build_3rdparty_cmake lomiri-url-dispatcher
        build_3rdparty_cmake qtmir
        build_3rdparty_cmake QtAV
    fi
    build_3rdparty_cmake QtZeroConf "-DBUILD_SHARED_LIBS=ON"
fi

# Find subprojects to build as requested
IFS=',' read -r -a PRJS <<< "$SUB_PROJECTS"
SRC_ARG=""
for P in "${PRJS[@]}"; do
    PROJ=$(echo "$P" | awk '{ print toupper($0) }')
    SRC_ARG="$SRC_ARG -DJUSTSIGNAGE_PROJECT_$PROJ=ON"
done

echo "Selected projects: $SUB_PROJECTS"

# Include click packaging metadata on Ubuntu Touch
UBUNTU_TOUCH_ARG=""
if [ "$UBUNTU_TOUCH" == "1" ]; then
    UBUNTU_TOUCH_ARG="-DJUSTSIGNAGE_CLICK=ON"
fi

# Build main sources
build_project "$UBUNTU_TOUCH_ARG $SRC_ARG"
