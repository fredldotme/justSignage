#!/bin/bash

SRC_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SRC_PATH

source common.sh

INSTALL=/opt/${PROJECT}-${VERSION}

export LD_LIBRARY_PATH=$INSTALL/lib
export QML2_IMPORT_PATH=$INSTALL/lib/qml:$INSTALL/lib/qt5/qml
export QT_QPA_PLATFORM_PLUGIN_PATH=$INSTALL/lib/qt5/plugins/platforms
export PATH=$PATH:$INSTALL/bin

SOCKET_NAME_TEMPLATE=justsignage-wayland-
WAYLAND_DISPLAY_TEMPLATE=${XDG_RUNTIME_DIR}/${SOCKET_NAME_TEMPLATE}
SOCKET_FOUND=0
i=0

while [ "$SOCKET_FOUND" == "0" ]; do
    i=$((i+1))
    WAYLAND_DISPLAY=${WAYLAND_DISPLAY_TEMPLATE}${i}
    if [ ! -e "$WAYLAND_DISPLAY" ]; then
        export WAYLAND_DISPLAY=${SOCKET_NAME_TEMPLATE}${i}
        SOCKET_FOUND=1
    fi
done

sudo glib-compile-schemas $INSTALL/share/glib-2.0/schemas

env \
    GSETTINGS_SCHEMA_DIR=$INSTALL/share/glib-2.0/schemas \
    QT_QPA_PLATFORM=mirserver \
    MIR_SERVER_CURSOR=null \
    $INSTALL/bin/justsignage-compositor &

sleep 1

for job in `jobs -p`; do
    wait $job
done
