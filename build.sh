# this is for linux only, on windows it's not going to work (cuz bash, duh)
# needs to be chmod +x beforehand in order to run
set -e

mkdir -p build

nasm -f win32 src/main.asm -o build/main.obj

# the bunch of settings to create the .exe via linux
# (comes from the mingw-w64-gcc package, any package manager should have it available to download)
i686-w64-mingw32-gcc -m32 \
    -nostdlib -nostartfiles \
    -Wl,-e,_start \
    build/main.obj \
    -o build/main.exe \
    -lkernel32         

echo "Build completed: build/main.exe"
