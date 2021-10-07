mkdir build
cd build

cmake ^
    -G "NMake Makefiles" ^
    -DCMAKE_INSTALL_PREFIX=%LIBRARY_PREFIX% ^
    -DCMAKE_BUILD_TYPE=Release ^
    -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True ^
    -DSKIP_ogre2:BOOL=ON ^
    -DSKIP_optix:BOOL=ON ^
    %SRC_DIR%
if errorlevel 1 exit 1

:: Build.
cmake --build . --config Release
if errorlevel 1 exit 1

:: Install.
cmake --build . --config Release --target install
if errorlevel 1 exit 1

:: Test.
:: Do not run tests as they require to open a display and this is not supported on CI at the moment
:: See https://github.com/conda-forge/libignition-rendering4-feedstock/pull/19#issuecomment-937678806
:: set RENDER_ENGINE_VALUES=ogre
:: ctest --output-on-failure -C Release -E "INTEGRATION|PERFORMANCE|REGRESSION|UNIT_RenderingIface_TEST|check_"
:: if errorlevel 1 exit 1
