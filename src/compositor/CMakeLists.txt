cmake_minimum_required(VERSION 3.14)

project(justsignage-compositor LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

# QtCreator supports the following variables for Android, which are identical to qmake Android variables.
# Check https://doc.qt.io/qt/deployment-android.html for more information.
# They need to be set before the find_package(...) calls below.

#if(ANDROID)
#    set(ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android")
#    if (ANDROID_ABI STREQUAL "armeabi-v7a")
#        set(ANDROID_EXTRA_LIBS
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libcrypto.so
#            ${CMAKE_CURRENT_SOURCE_DIR}/path/to/libssl.so)
#    endif()
#endif()

find_package(QT NAMES Qt6 Qt5 COMPONENTS Core Quick REQUIRED)
find_package(Qt${QT_VERSION_MAJOR} COMPONENTS Core DBus Quick REQUIRED)

include(FindPkgConfig)
pkg_check_modules(MIRSERVER mirserver>=0.26 REQUIRED)
pkg_check_modules(MIRCLIENT mirclient>=0.26 REQUIRED)
pkg_check_modules(MIRRENDERERGLDEV mir-renderer-gl-dev>=0.26 REQUIRED)
pkg_check_modules(MIRAL miral>=1.1.0 REQUIRED)
pkg_check_modules(QTMIRSERVER qtmirserver>=0.6.1 REQUIRED)
pkg_check_modules(GIO REQUIRED gio-unix-2.0 REQUIRED)

include_directories(
    SYSTEM

    ${MIRSERVER_INCLUDE_DIRS}
    ${MIRCLIENT_INCLUDE_DIRS}
    ${MIRRENDERERGLDEV_INCLUDE_DIRS}
    ${MIRAL_INCLUDE_DIRS}
    ${QTMIRSERVER_INCLUDE_DIRS}
)

set(PROJECT_SOURCES
    main.cpp
    dbusinterface.cpp
    screens.cpp
    screenwindow.cpp
    pointerposition.cpp
    communitynotifier.cpp
    qml.qrc
)

if(${QT_VERSION_MAJOR} GREATER_EQUAL 6)
    qt_add_executable(justsignage-compositor
        ${PROJECT_SOURCES}
    )
else()
    if(ANDROID)
        add_library(justsignage-compositor SHARED
            ${PROJECT_SOURCES}
        )
    else()
        add_executable(justsignage-compositor
          ${PROJECT_SOURCES}
        )
    endif()
endif()

target_compile_definitions(justsignage-compositor
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(
    justsignage-compositor

    PRIVATE Qt${QT_VERSION_MAJOR}::Core
    Qt${QT_VERSION_MAJOR}::Quick
    Qt${QT_VERSION_MAJOR}::DBus

    ${QTMIRSERVER_LDFLAGS}
    ${MIRAL_LDFLAGS}
)

install(TARGETS justsignage-compositor DESTINATION bin)
