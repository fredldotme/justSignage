project(justSignage)

option(JUSTSIGNAGE_PROJECT_ALL "Build all subprojects" OFF)

option(JUSTSIGNAGE_PROJECT_COMPOSITOR "Build the compositor" OFF)
option(JUSTSIGNAGE_PROJECT_VIDEOPLAYER "Build the QtMultimedia player" OFF)
option(JUSTSIGNAGE_PROJECT_WEBPLAYER "Build the QtWebEngine player" OFF)
option(JUSTSIGNAGE_PROJECT_IMAGEPLAYER "Build the Qt-based image player" OFF)
option(JUSTSIGNAGE_PROJECT_QTAVPLAYER "Build the QtAV video player" OFF)
option(JUSTSIGNAGE_PROJECT_MARQUEEPLAYER "Build the Marquee overlay" OFF)
option(JUSTSIGNAGE_PROJECT_REMOTE "Build the remote control app" OFF)

option(JUSTSIGNAGE_CLICK "Build with click package metadata" OFF)

if (JUSTSIGNAGE_PROJECT_ALL)
  set(JUSTSIGNAGE_PROJECT_COMPOSITOR ON)
  set(JUSTSIGNAGE_PROJECT_VIDEOPLAYER ON)
  set(JUSTSIGNAGE_PROJECT_WEBPLAYER ON)
  set(JUSTSIGNAGE_PROJECT_IMAGEPLAYER ON)
  set(JUSTSIGNAGE_PROJECT_QTAVPLAYER ON)
  set(JUSTSIGNAGE_PROJECT_MARQUEEPLAYER ON)
  set(JUSTSIGNAGE_PROJECT_REMOTE ON)
endif()

if (JUSTSIGNAGE_PROJECT_COMPOSITOR)
  add_subdirectory(compositor)
endif()

if (JUSTSIGNAGE_PROJECT_VIDEOPLAYER)
  add_subdirectory(videoplayer)
endif()

if (JUSTSIGNAGE_PROJECT_WEBPLAYER)
  add_subdirectory(webplayer)
endif()

if (JUSTSIGNAGE_PROJECT_IMAGEPLAYER)
  add_subdirectory(imageplayer)
endif()

if (JUSTSIGNAGE_PROJECT_QTAVPLAYER)
  add_subdirectory(qtavplayer)
endif()

if (JUSTSIGNAGE_PROJECT_MARQUEEPLAYER)
  add_subdirectory(marqueeplayer)
endif()

if (JUSTSIGNAGE_PROJECT_REMOTE)
  add_subdirectory(remote)
endif()

if (JUSTSIGNAGE_CLICK)
  message("Build with click metadata")
  add_subdirectory(click)
endif()
