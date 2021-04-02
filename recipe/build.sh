#!/bin/sh

mkdir build
cd build

export CFLAGS="${CFLAGS} -DGLX_GLXEXT_LEGACY"
export CXXFLAGS="${CXXFLAGS} -DGLX_GLXEXT_LEGACY"

cmake .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True

cmake --build . --config Release
cmake --build . --config Release --target install
# UNIT_Heightmap_TEST disabled for https://github.com/conda-forge/libignition-rendering4-feedstock/issues/10
ctest --output-on-failure -C Release -E "INTEGRATION|PERFORMANCE|REGRESSION|UNIT_RenderingIface_TEST|check_UNIT_RenderingIface_TEST|UNIT_Heightmap_TEST"
