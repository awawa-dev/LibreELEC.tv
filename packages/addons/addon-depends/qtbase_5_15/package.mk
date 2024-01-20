# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2009-2016 Lukas Rusak (lrusak@libreelec.tv)
# Copyright (C) 2019-present Team LibreELEC (https://libreelec.tv)

PKG_NAME="qtbase_5_15"
PKG_VERSION="5.15.4"
PKG_SHA256="615ff68d7af8eef3167de1fd15eac1b150e1fd69d1e2f4239e54447e7797253b"
PKG_LICENSE="GPL"
PKG_SITE="http://qt-project.org"
PKG_URL="https://download.qt.io/archive/qt/${PKG_VERSION%.*}/${PKG_VERSION}/single/qt-everywhere-opensource-src-${PKG_VERSION}.tar.xz"
PKG_DEPENDS_TARGET="freetype libjpeg-turbo libpng openssl sqlite zlib"
PKG_LONGDESC="A cross-platform application and UI framework."
PKG_BUILD_FLAGS="-sysroot"

PKG_CONFIGURE_OPTS_TARGET="-prefix /usr
                           -sysroot "${SYSROOT_PREFIX}"
                           -hostprefix "${TOOLCHAIN}"
                           -device linux-libreelec-g++
                           -opensource -confirm-license
                           -release
                           -static
                           -make libs
                           -force-pkg-config
                           -openssl-linked
                           -no-accessibility
                           -qt-sqlite
                           -no-sql-mysql
                           -system-zlib
                           -no-mtdev
                           -qt-libjpeg
                           -qt-libpng
                           -no-harfbuzz
                           -no-libproxy
                           -system-pcre
                           -no-glib
                           -silent
                           -no-cups
                           -no-iconv
                           -no-evdev
                           -no-tslib
                           -no-icu
                           -no-strip
                           -no-fontconfig                           
                           -no-opengl
                           -no-libudev
                           -no-libinput
                           -no-eglfs
                           -no-egl
                           -skip qt3d
                           -skip qtactiveqt
                           -skip qtandroidextras
                           -skip qtcanvas3d
                           -skip qtconnectivity
                           -skip qtdeclarative
                           -skip qtdoc
                           -skip qtgraphicaleffects
                           -skip qtimageformats
                           -skip qtlocation
                           -skip qtmacextras
                           -skip qtmultimedia
                           -skip qtquickcontrols
                           -skip qtquickcontrols2
                           -skip qtscript
                           -skip qtsensors
                           -skip qtserialbus
                           -skip qtsvg
                           -skip qttranslations
                           -skip qtwayland
                           -skip qtwebchannel
                           -skip qtwebengine
                           -skip qtwebsockets
                           -skip qtwebview
                           -skip qtwinextras
                           -skip qtx11extras
                           -skip qtxmlpatterns"

configure_target() {
  QMAKE_CONF_DIR="qtbase/mkspecs/devices/linux-libreelec-g++"

  cd ..
  mkdir -p ${QMAKE_CONF_DIR}

  cat >"${QMAKE_CONF_DIR}/qmake.conf" <<EOF
MAKEFILE_GENERATOR      = UNIX
CONFIG                 += incremental
QMAKE_INCREMENTAL_STYLE = sublib
include(../../common/linux.conf)
include(../../common/gcc-base-unix.conf)
include(../../common/g++-unix.conf)
load(device_config)
QMAKE_CC         = ${CC}
QMAKE_CXX        = ${CXX}
QMAKE_LINK       = ${CXX}
QMAKE_LINK_SHLIB = ${CXX}
QMAKE_AR         = ${AR} cqs
QMAKE_OBJCOPY    = ${OBJCOPY}
QMAKE_NM         = ${NM} -P
QMAKE_STRIP      = ${STRIP}
QMAKE_CFLAGS     = ${CFLAGS}
QMAKE_CXXFLAGS   = ${CXXFLAGS}
QMAKE_LFLAGS     = ${LDFLAGS}
load(qt_config)
EOF

  cat >"${QMAKE_CONF_DIR}/qplatformdefs.h" <<EOF
#include "../../linux-g++/qplatformdefs.h"
EOF

  unset CC CXX LD RANLIB AR AS CPPFLAGS CFLAGS LDFLAGS CXXFLAGS
  ./configure ${PKG_CONFIGURE_OPTS_TARGET}
}
