# SPDX-License-Identifier: GPL-2.0-or-later
# Copyright (C) 2018-present Team CoreELEC (https://coreelec.org)

PKG_NAME="hyperhdr"
PKG_VERSION="6d5eff19d777b31a1969fc030e5e202b9c88a8cd"
PKG_REV="202"
PKG_LICENSE="MiT"
PKG_SITE="https://github.com/awawa-dev/HyperHDR"
PKG_URL="https://github.com/awawa-dev/HyperHDR.git"
GET_HANDLER_SUPPORT="git"
PKG_DEPENDS_TARGET="toolchain qtbase_5_15 pkg-config libjpeg-turbo alsa"
PKG_TOOLCHAIN="cmake"
PKG_SECTION="service"
PKG_SHORTDESC="HyperHDR: an ambient lighting controller"
PKG_LONGDESC="HyperHDR is an opensource ambient lighting implementation."

PKG_IS_ADDON="yes"
PKG_ADDON_NAME="HyperHDR"
PKG_ADDON_TYPE="xbmc.service"
PKG_BUILD_FLAGS="-sysroot"

# Setting default values
PKG_PLATFORM="-DPLATFORM=linux"

if [ "$LINUX" = "raspberrypi" ]; then
  PKG_PLATFORM="-DPLATFORM=rpi -DENABLE_WS281XPWM=ON"
  PKG_DEPENDS_TARGET="$PKG_DEPENDS_TARGET rpi_ws281x"
fi

PKG_PLATFORM="$PKG_PLATFORM -DENABLE_FRAMEBUFFER=OFF -DENABLE_PIPEWIRE=OFF -DENABLE_X11=OFF -DENABLE_CEC=OFF"

PKG_CMAKE_OPTS_TARGET="-DCMAKE_NO_SYSTEM_FROM_IMPORTED=ON \
                       -DCMAKE_BUILD_TYPE=Release \
                       -DUSE_STATIC_QT_PLUGINS=ON \
                       $PKG_PLATFORM \
                       -Wno-dev"

addon() {
  mkdir -p ${ADDON_BUILD}/${PKG_ADDON_ID}/{bin,lib,lut}  
  rm $(get_install_dir hyperhdr)/usr/share/hyperhdr/bin/hyperhdr-remote || true
  cp -r -P -p $(get_install_dir hyperhdr)/usr/share/hyperhdr/bin/* ${ADDON_BUILD}/${PKG_ADDON_ID}/bin
  cp $(get_install_dir hyperhdr)/usr/share/hyperhdr/lib/* ${ADDON_BUILD}/${PKG_ADDON_ID}/lib || true
  tar -xf $(get_install_dir hyperhdr)/usr/share/hyperhdr/lut/lut_lin_tables.tar.xz -C ${ADDON_BUILD}/${PKG_ADDON_ID}/lut
}
