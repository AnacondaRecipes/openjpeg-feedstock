mkdir build
cd build

:: Download data for running the tests.
git clone https://github.com/uclouvain/openjpeg-data.git data

:: Configure.
cmake -GNinja ^
      -D CMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      %CMAKE_ARGS% ^
      -D CMAKE_BUILD_TYPE=Release ^
      -D BUILD_SHARED_LIBS=ON ^
      -D BUILD_UNIT_TESTS=ON ^
      -D OPJ_DATA_ROOT=data ^
      -D TIFF_LIBRARY=%LIBRARY_LIB%\tiff.lib ^
      -D TIFF_INCLUDE_DIR=%LIBRARY_INC% ^
      -D PNG_LIBRARY_RELEASE=%LIBRARY_LIB%\libpng.lib ^
      -D PNG_PNG_INCLUDE_DIR=%LIBRARY_INC% ^
      -D ZLIB_LIBRARY=%LIBRARY_LIB%\zlib.lib ^
      -D ZLIB_INCLUDE_DIR=%LIBRARY_INC% ^
      %SRC_DIR%

:: Build.
cmake --build . --config Release --verbose
if errorlevel 1 exit 1

:: Test.
ctest -C Release --verbose
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install --verbose
if errorlevel 1 exit 1
