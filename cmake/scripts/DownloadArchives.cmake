set(ROOT ${CMAKE_CURRENT_LIST_DIR}/../..)
set(DL_ROOT ${ROOT}/tmp_dl)

include(${CMAKE_CURRENT_LIST_DIR}/uris.cmake)

function(dlfile var)
    set(uri ${${var}_uri})
    set(fn ${${var}_filename})
    set(pth ${DL_ROOT}/${fn})

    message(STATUS "Download: ${uri} => ${fn}")
    file(DOWNLOAD ${uri} ${pth}
        SHOW_PROGRESS)
endfunction()

message(STATUS "DL_ROOT: ${DL_ROOT}")

file(MAKE_DIRECTORY ${DL_ROOT})

dlfile(msys2)
dlfile(sevenzip)
dlfile(llvm)
dlfile(wabt)
dlfile(ninja)
dlfile(cmake)
