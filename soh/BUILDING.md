# Building from source Ship of Harkinian

## Install WSL and chroot
1. 	Install wsl and ubuntu (use wsl2), and once installed and started:
```
sudo apt update
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common qemu-user-static debootstrap
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=$(dpkg --print-architecture)] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt install docker-ce -y
sudo docker run --rm --privileged multiarch/qemu-user-static --reset -p yes
sudo qemu-debootstrap --arch arm64 bookworm /mnt/data/arm64 http://deb.debian.org/debian/
```
 -- Use bullseye instead of bookworm if building compatibility.

Note: The folder `/mnt/data/arm64` can be modified, for example to `/mnt/data/bookworm-arm64`. This is useful if you like to maintain multiple chroots.

## Enter chroot and install dependencies
```
sudo chroot /mnt/data/arm64/
apt -y install gcc g++ git cmake ninja-build lsb-release libsdl2-dev libpng-dev libsdl2-net-dev libzip-dev zipcmp zipmerge ziptool nlohmann-json3-dev libtinyxml2-dev libspdlog-dev libboost-dev libopengl-dev libglew-dev
```

### Bullseye and older (newer cmake)
```
wget https://github.com/Kitware/CMake/releases/download/v3.24.4/cmake-3.24.4-linux-aarch64.sh
chmod +x cmake-3.24.4-linux-aarch64.sh
./cmake-3.24.4-linux-aarch64.sh --prefix=/usr
echo 'export PATH=/usr/cmake-3.24.4-linux-aarch64/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

Note: You may need to build and install tinyxml2 from source

## Build Shipwright
```
git clone https://github.com/HarbourMasters/Shipwright.git && cd Shipwright
git checkout tags/x.x.x
git submodule update --init --recursive
cmake -H. -Bbuild-cmake -GNinja -DUSE_OPENGLES=1 -DBUILD_CROWD_CONTROL=0 -DCMAKE_BUILD_TYPE=Release
cmake --build build-cmake --config Release --target GenerateSohOtr
cmake --build build-cmake --config Release -j$(nproc)
```
Note: If building for anything using a GLIBC version older than GLIBC_2.36, use the `8.0.4` release tag. ASnything newer than that will have poor performance.

## Retrieve the binaries
```
cd build-cmake/soh
strip soh.elf
```

- Copy the `.elf` to `roms/ports/soh/bin/` as `performance.elf` or `compatibility.elf` (if you used bullseye) and copy `soh.otr` to `roms/ports/soh`.
- Copy the `build-cmake/assets` folder to `ports/soh` and copy `build-cmake/ZAPD/ZAPD.out` to `ports/soh/assets/extractor`.
- If the build is a new version open `ports/soh/assets/extractor/otrgen` with a text editor and edit `--portVer` around Line 50 to match the release version you pulled.
