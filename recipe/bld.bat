mkdir -p %SRC_DIR%\build
cd %SRC_DIR%\build

set BUILD_TYPE=Release

:: # Download the data repository required to run the tests into <root>/build/data
git clone https://github.com/uclouvain/openjpeg-data.git data
if errorlevel 1 exit 1

:: Enable tests by passing BUILD_TESTING (ctest), BUILD_UNIT_TESTS
:: Pass the directory of the data repository via OPJ_DATA_ROOT

:: Configure
cmake -GNinja ^
      -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
      %CMAKE_ARGS% ^
      -DCMAKE_BUILD_TYPE=%BUILD_TYPE% ^
      -DBUILD_SHARED_LIBS=ON ^
      -DBUILD_UNIT_TESTS=ON ^
      -DBUILD_TESTING=ON ^
      -DOPJ_DATA_ROOT=%SRC_DIR%\build\data ^
      -DTIFF_LIBRARY=%LIBRARY_LIB%\tiff.lib ^
      -DTIFF_INCLUDE_DIR=%LIBRARY_INC% ^
      -DPNG_LIBRARY_RELEASE=%LIBRARY_LIB%\libpng.lib ^
      -DPNG_PNG_INCLUDE_DIR=%LIBRARY_INC% ^
      -DZLIB_LIBRARY=%LIBRARY_LIB%\zlib.lib ^
      -DZLIB_INCLUDE_DIR=%LIBRARY_INC% ^
      %SRC_DIR%
if errorlevel 1 exit 1

:: Build and install
cmake --build . --config %BUILD_TYPE% --target install --verbose
if errorlevel 1 exit 1

:: Test
ctest -C %BUILD_TYPE% --verbose --exclude-from-file "..\knownfailures-win-64.txt"
if errorlevel 1 exit 1
