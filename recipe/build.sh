#!/bin/bash

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${target_platform} == osx-64 ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
fi

mkdir build || true
pushd build

  git clone https://github.com/uclouvain/openjpeg-data.git data

  cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
        $CMAKE_ARGS \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_UNIT_TESTS=ON \
        -DBUILD_TESTING=ON \
        -DOPJ_DATA_ROOT=data \
        -DTIFF_LIBRARY=$PREFIX/lib/libtiff${SHLIB_EXT} \
        -DTIFF_INCLUDE_DIR=$PREFIX/include \
        -DPNG_LIBRARY_RELEASE=$PREFIX/lib/libpng${SHLIB_EXT} \
        -DPNG_PNG_INCLUDE_DIR=$PREFIX/include \
        -DZLIB_LIBRARY=$PREFIX/lib/libz${SHLIB_EXT} \
        -DZLIB_INCLUDE_DIR=$PREFIX/include \
        "${CMAKE_PLATFORM_FLAGS[@]}" \
        ..

  cmake --build . --config Release --parallel ${CPU_COUNT} --verbose
  ctest -C Release -j${CPU_COUNT} --verbose
  cmake --build . --config Release --target install --parallel ${CPU_COUNT}

popd
