## Building from source
To maintain compatibility with ArkOS, which uses an older GLIBC, we compile on debian bullseye chroot. This guide assumes you already have one set up. Install dependencies first, 
but because debian bullseye stable has an outdated package manager, we must also manually install newer cmake, libsdl, libzip, and sdl2_net.  

Be warned, this compiled version is VERY SLOW.

```
apt-get install gcc g++ git cmake ninja-build lsb-release libsdl2-dev libpng-dev libsdl2-net-dev libzip-dev zipcmp zipmerge ziptool libboost-dev libopengl-dev ninja-build lsb-release

wget https://cmake.org/files/LatestRelease/cmake-3.29.0.tar.gz
tar xzf cmake-3.29.0.tar.gz
cd cmake-3.29.0
./configure
make
make install

wget https://www.libsdl.org/release/SDL2-2.28.5.tar.gz 
tar -xzf SDL2-2.28.5.tar.gz 
cd SDL2-2.28.5 
./configure --enable-hidapi-libusb
make
make install
cp -av /usr/local/lib/libSDL* /lib/aarch64-linux-gnu/

wget https://libzip.org/download/libzip-1.10.1.tar.gz 
tar -xzvf libzip-1.10.1.tar.gz 
cd libzip-1.10.1 
mkdir build 
cd build 
cmake .. 
make 
make install 

wget https://www.libsdl.org/projects/SDL_net/release/SDL2_net-2.2.0.tar.gz 
tar -xzf SDL2_net-2.2.0.tar.gz 
cd SDL2_net-2.2.0
./configure
make
make install
cp -av /usr/local/lib/libSDL* /lib/aarch64-linux-gnu/

git clone https://github.com/HarbourMasters/Shipwright.git
cd Shipwright
git submodule update --init
cmake --no-warn-unused-cli -H. -Bbuild-cmake -GNinja -DUSE_OPENGLES=ON -DCMAKE_BUILD_TYPE:STRING=Release
cmake --build build-cmake --config Release --target GenerateSohOtr 
cmake --build build-cmake --config Release

strip build-cmake/soh/soh.elf
```