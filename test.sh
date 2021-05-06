#!/bin/bash

SRC_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SRC_PATH

source common.sh

INSTALL=/opt/${PROJECT}-${VERSION}

export LD_LIBRARY_PATH=$INSTALL/lib
export QML2_IMPORT_PATH=$INSTALL/lib/qml:$INSTALL/lib/qt5/qml
export QT_QPA_PLATFORM_PLUGIN_PATH=$INSTALL/lib/qt5/plugins/platforms

sudo glib-compile-schemas $INSTALL/share/glib-2.0/schemas

#MIR_SERVER_X11_OUTPUT=1500x1200:1500x1200

env \
    GSETTINGS_SCHEMA_DIR=$INSTALL/share/glib-2.0/schemas \
    QT_QPA_PLATFORM=mirserver \
    MIR_SERVER_CURSOR=null \
    $INSTALL/bin/justsignage-compositor &

sleep 3

QT_QPA_PLATFORM=wayland $INSTALL/bin/justsignage-imageplayer &
#QT_QPA_PLATFORM=wayland $INSTALL/bin/justsignage-webplayer &
QT_QPA_PLATFORM=wayland $INSTALL/bin/justsignage-webplayer &
QT_QPA_PLATFORM=wayland $INSTALL/bin/justsignage-webplayer &
QT_QPA_PLATFORM=wayland $INSTALL/bin/justsignage-videoplayer &
#QT_QPA_PLATFORM=wayland ./src/build/qtavplayer/qtavplayer &
#mpv --geometry=800x600 --gpu-context=wayland --mute=yes '/home/alfred/Videos/4k.mkv' &

for job in `jobs -p`; do
    wait $job
done
