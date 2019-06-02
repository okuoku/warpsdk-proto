set HERE=%~dp0
set ROOT=%HERE%msys64
set HOME=/home
set MSYSTEM=MINGW64

COPY %HERE%msys-setup.sh %ROOT%\mysetup.sh
%ROOT%\usr\bin\bash --login /mysetup.sh
