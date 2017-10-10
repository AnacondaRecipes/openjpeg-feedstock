#!/bin/bash

mkdir build && cd build

cmake -D CMAKE_INSTALL_PREFIX=$PREFIX \
      -D TIFF_LIBRARY=$PREFIX/lib/libtiff${SHLIB_EXT} \
      -D TIFF_INCLUDE_DIR=$PREFIX/include \
      -D PNG_LIBRARY_RELEASE=$PREFIX/lib/libpng${SHLIB_EXT} \
      -D PNG_PNG_INCLUDE_DIR=$PREFIX/include \
      -D ZLIB_LIBRARY=$PREFIX/lib/libz${SHLIB_EXT} \
      -D ZLIB_INCLUDE_DIR=$PREFIX/include \
      $SRC_DIR

make -j${CPU_COUNT} ${VERBOSE_CM}
ctest
make install -j${CPU_COUNT}
make clean
