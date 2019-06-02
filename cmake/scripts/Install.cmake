set(ROOT ${CMAKE_CURRENT_LIST_DIR}/../..)
set(TMP_ROOT ${ROOT}/tmp_expand)
set(INSTALL_ROOT ${ROOT}/install)

get_filename_component(TMP_ROOT ${TMP_ROOT} ABSOLUTE)
get_filename_component(INSTALL_ROOT ${INSTALL_ROOT} ABSOLUTE)

if(EXISTS ${INSTALL_ROOT})
    message(STATUS "Removedir: ${INSTALL_ROOT}")
    file(REMOVE_RECURSE "${INSTALL_ROOT}")
endif()
file(MAKE_DIRECTORY ${INSTALL_ROOT})

# cmake
file(GLOB cmake_dir ${TMP_ROOT}/cmake/*)
message(STATUS "cmake_dir: ${cmake_dir}")
if(NOT IS_DIRECTORY ${cmake_dir})
    message(FATAL_ERROR "Huh?: ${cmake_dir}")
endif()

file(RENAME ${cmake_dir} ${INSTALL_ROOT}/cmake)

# llvm
file(MAKE_DIRECTORY ${INSTALL_ROOT}/llvm)
foreach(d bin include lib libexec share)
    file(RENAME ${TMP_ROOT}/llvm/${d} ${INSTALL_ROOT}/llvm/${d})
endforeach()

# msys2
file(MAKE_DIRECTORY ${INSTALL_ROOT}/x86_64-w64-mingw32)
file(MAKE_DIRECTORY ${INSTALL_ROOT}/i686-w64-mingw32)
foreach(d include lib)
    file(RENAME ${TMP_ROOT}/msys2/msys64/mingw32/i686-w64-mingw32/${d}
        ${INSTALL_ROOT}/i686-w64-mingw32/${d})
    file(RENAME ${TMP_ROOT}/msys2/msys64/mingw64/x86_64-w64-mingw32/${d}
        ${INSTALL_ROOT}/x86_64-w64-mingw32/${d})
endforeach()

# ninja
file(RENAME ${TMP_ROOT}/ninja/ninja.exe ${INSTALL_ROOT}/cmake/bin/ninja.exe)

# wabt
file(RENAME ${TMP_ROOT}/wabt ${INSTALL_ROOT}/wabt)
