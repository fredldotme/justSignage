#!/bin/bash

export LD_LIBRARY_PATH=/opt/justSignage-current/lib
export QML2_IMPORT_PATH=/opt/justSignage-current/lib/qml:/opt/justSignage-current/lib/qt5/qml
export QT_QPA_PLATFORM_PLUGIN_PATH=/opt/justSignage-current/lib/qt5/plugins/platforms

SRC_PATH="$( cd -- "$(dirname "$0")" >/dev/null 2>&1 ; pwd -P )"
cd $SRC_PATH

env QT_QPA_PLATFORM=mirserver MIR_SERVER_CURSOR=null src/build/compositor/src &

sleep 3

QT_QPA_PLATFORM=wayland ./src/build/imageplayer/imageplayer &
sleep 2
QT_QPA_PLATFORM=wayland ./src/build/webplayer/webplayer &
QT_QPA_PLATFORM=wayland ./src/build/videoplayer/videoplayer &
QT_QPA_PLATFORM=wayland ./src/build/qtavplayer/qtavplayer &

for job in `jobs -p`; do
    wait $job
done
