set(ROOT ${CMAKE_CURRENT_LIST_DIR}/../..)
set(DL_ROOT ${ROOT}/tmp_dl)
set(TMP_ROOT ${ROOT}/tmp_expand)

get_filename_component(DL_ROOT ${DL_ROOT} ABSOLUTE)
get_filename_component(TMP_ROOT ${TMP_ROOT} ABSOLUTE)

include(${CMAKE_CURRENT_LIST_DIR}/uris.cmake)

function(expand_msi var)
    set(fn ${${var}_filename})
    set(pth ${DL_ROOT}/${fn})
    set(out ${TMP_ROOT}/${var})
    file(TO_NATIVE_PATH ${out} out_native)

    if(EXISTS ${out})
        message(STATUS "Removedir: ${out}")
        file(REMOVE_RECURSE "${out}")
    endif()
    file(MAKE_DIRECTORY ${out})
    message(STATUS "Expand(msi): ${fn} => ${var}")
    execute_process(
        COMMAND
        msiexec /a ${fn}
        targetdir=${out_native}
        /qn /li log.log
        WORKING_DIRECTORY ${DL_ROOT}
        RESULT_VARIABLE rr)

    if(rr)
        message(FATAL_ERROR "Error: ${rr}")
    endif()
endfunction()

function(expand_nsis sevenzip var)
    set(fn ${${var}_filename})
    set(pth ${DL_ROOT}/${fn})
    set(out ${TMP_ROOT}/${var})

    if(EXISTS ${out})
        message(STATUS "Removedir: ${out}")
        file(REMOVE_RECURSE "${out}")
    endif()
    file(MAKE_DIRECTORY ${out})
    message(STATUS "Expand(nsis): ${fn} => ${var}")

    execute_process(
        COMMAND
        ${sevenzip} x ${pth}
        WORKING_DIRECTORY ${out}
        RESULT_VARIABLE rr)

    if(rr)
        message(FATAL_ERROR "Error: ${rr}")
    endif()
endfunction()

function(expand_zip var)
    set(fn ${${var}_filename})
    set(pth ${DL_ROOT}/${fn})
    set(out ${TMP_ROOT}/${var})
    if(EXISTS ${out})
        message(STATUS "Removedir: ${out}")
        file(REMOVE_RECURSE "${out}")
    endif()
    file(MAKE_DIRECTORY ${out})
    message(STATUS "Expand(zip): ${fn} => ${var}")

    execute_process(
        COMMAND ${CMAKE_COMMAND}
        -E tar xvf ${pth}
        WORKING_DIRECTORY ${out}
        RESULT_VARIABLE rr)

    if(rr)
        message(FATAL_ERROR "Error: ${rr}")
    endif()
endfunction()

function(install_msys)
    set(root ${TMP_ROOT}/msys2)
    file(COPY 
        ${CMAKE_CURRENT_LIST_DIR}/do-msys-setup.bat
        ${CMAKE_CURRENT_LIST_DIR}/msys-setup.sh
        DESTINATION
        ${root})
    execute_process(
        COMMAND cmd /c
        ${root}/do-msys-setup.bat
        RESULT_VARIABLE rr
        )
    if(rr)
        message(FATAL_ERROR "Error: ${rr}")
    endif()
endfunction()

expand_msi(sevenzip)
expand_nsis(${TMP_ROOT}/sevenzip/Files/7-Zip/7z.exe
    llvm)
expand_zip(msys2)
expand_zip(wabt)
expand_zip(ninja)
expand_zip(cmake)

install_msys()
