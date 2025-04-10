@echo off
setlocal

if not exist build mkdir build

nasm -f win32 src\main.asm -o build\main.obj

rem if it's causing any problem in, idk, windows 11, remove the flag -Wl,--subsystem,console,5.01 
gcc -m32 -nostdlib -nostartfiles -Wl,-e,_start -Wl,--subsystem,console,5.01 build\main.obj -o build\hello.exe -lkernel32

echo Completed: build\hello.exe
endlocal