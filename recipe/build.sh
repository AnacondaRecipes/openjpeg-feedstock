#!/bin/bash

declare -a CMAKE_PLATFORM_FLAGS
if [[ ${target_platform} == osx-64 ]]; then
  CMAKE_PLATFORM_FLAGS+=(-DCMAKE_OSX_SYSROOT="${CONDA_BUILD_SYSROOT}")
fi

mkdir -p build || true
pushd build

  # Enable tests by passing BUILD_TESTING (ctest), BUILD_UNIT_TESTS
  # Pass the directory of the data repository via OPJ_DATA_ROOT

  # Configure
  cmake -DCMAKE_INSTALL_PREFIX=$PREFIX \
        $CMAKE_ARGS \
        -DCMAKE_BUILD_TYPE=Release \
        -DBUILD_SHARED_LIBS=ON \
        -DBUILD_UNIT_TESTS=ON \
        -DBUILD_TESTING=ON \
        -DOPJ_DATA_ROOT=$SRC_DIR/opj_data \
        -DTIFF_LIBRARY=$PREFIX/lib/libtiff${SHLIB_EXT} \
        -DTIFF_INCLUDE_DIR=$PREFIX/include \
        -DPNG_LIBRARY_RELEASE=$PREFIX/lib/libpng${SHLIB_EXT} \
        -DPNG_PNG_INCLUDE_DIR=$PREFIX/include \
        -DZLIB_LIBRARY=$PREFIX/lib/libz${SHLIB_EXT} \
        -DZLIB_INCLUDE_DIR=$PREFIX/include \
        "${CMAKE_PLATFORM_FLAGS[@]}" \
        ..

  # Build and install
  cmake --build . --config Release --parallel ${CPU_COUNT} --target install --verbose

  # Test
  if [[ -f "../knownfailures-${target_platform}.txt" ]]; then
    ctest -C Release -j"${CPU_COUNT}" --verbose --exclude-from-file "../knownfailures-${target_platform}.txt"
  else
    echo "Warning: Known failures file not found for target platform: ${target_platform}"
    ctest -C Release -j"${CPU_COUNT}" --verbose
  fi

popd
