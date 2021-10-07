#!/bin/sh

mkdir build
cd build

export CFLAGS="${CFLAGS} -DGLX_GLXEXT_LEGACY"
export CXXFLAGS="${CXXFLAGS} -DGLX_GLXEXT_LEGACY"

cmake ${CMAKE_ARGS} .. \
      -DCMAKE_BUILD_TYPE=Release \
      -DCMAKE_PREFIX_PATH=$PREFIX -DCMAKE_INSTALL_PREFIX=$PREFIX \
      -DCMAKE_INSTALL_LIBDIR=lib \
      -DCMAKE_INSTALL_SYSTEM_RUNTIME_LIBS_SKIP=True \
      -DFREEIMAGE_RUNS:BOOL=ON \
      -DFREEIMAGE_RUNS__TRYRUN_OUTPUT:STRING="" \
      -DFREEIMAGE_COMPILES:BOOL=ON \
      -DSKIP_ogre2:BOOL=ON \
      -DSKIP_optix:BOOL=ON

cmake --build . --config Release
cmake --build . --config Release --target install

# UNIT_Heightmap_TEST disabled for https://github.com/conda-forge/libignition-rendering4-feedstock/issues/10
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
# See https://github.com/conda-forge/libignition-rendering4-feedstock/pull/19#issuecomment-937538559
export RENDER_ENGINE_VALUES=ogre
ctest --extra-verbose --output-on-failure -C Release -E "INTEGRATION|PERFORMANCE|REGRESSION|UNIT_RenderingIface_TEST|check_UNIT_RenderingIface_TEST|UNIT_Heightmap_TEST"
fi
