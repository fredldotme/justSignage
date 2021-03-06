#!/bin/bash

sudo apt install -y --no-install-recommends \
    build-essential \
    cmake \
    cmake-extras \
    python3-chardet \
    python3-setuptools \
    google-mock \
    libgmock-dev \
    libgtest-dev \
    libboost-all-dev \
    pkgconf \
    libproperties-cpp-dev \
    libprocess-cpp-dev \
    libglib2.0-dev \
    libgirepository1.0-dev \
    libjson-glib-dev \
    libgee-0.8-dev \
    valac-bin \
    valac-0.48-vapi \
    liblttng-ust-dev \
    libzeitgeist-2.0-dev \
    libdbus-1-dev \
    libdbustest1-dev \
    libmirserver-dev \
    libmirclient-dev \
    libmircookie-dev \
    libmirrenderer-dev \
    libmiral-dev \
    libmircore-dev \
    mirtest-dev \
    mir-renderer-gl-dev \
    libmirwayland-dev \
    libwayland-dev \
    qtwayland5 \
    qtbase5-dev \
    qtbase5-private-dev \
    qtdeclarative5-dev \
    qtdeclarative5-private-dev \
    qtwebengine5-dev \
    qtmultimedia5-dev \
    libqt5opengl5-dev \
    libqt5sensors5-dev \
    libqtdbustest1-dev \
    libqtdbusmock1-dev \
    qml-module-qtquick-controls2 \
    qml-module-qtmultimedia \
    qml-module-qtwebchannel \
    qml-module-qtwebengine \
    libqt5multimedia5-plugins \
    libgsettings-qt-dev \
    libcurl4-openssl-dev \
    libsqlite3-dev \
    libapparmor-dev \
    libfontconfig1-dev \
    libopenal-dev \
    libavahi-client-dev \
    libavahi-common-dev \
    gettext \
    intltool \
    libtool \
    valgrind

if [ $(uname -p) == "aarch64" ]; then
    sudo apt install -y --no-install-recommends \
        libraspberrypi-dev
fi
