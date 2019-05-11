set MYDIR=%~dp0
set CMAKE=c:/lib/cmake/bin/cmake.exe
set NINJA=c:/lib/cmake/bin/ninja.exe

%CMAKE% -G Ninja -DCMAKE_MAKE_PROGRAM=%NINJA% -DCMAKE_TOOLCHAIN_FILE=%MYDIR%cmake/Modules/Platform/Yuniwarp.cmake %*

