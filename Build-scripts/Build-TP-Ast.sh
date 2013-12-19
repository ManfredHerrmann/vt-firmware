#! /bin/sh

# Build script for TP Link devices

echo ""

# Check to see if setup has already run
if [ ! -f ./already_configured ]; then 
  # make sure it only executes once
  touch ./already_configured  
  echo " Make builds directory"
  mkdir ./bin/
  mkdir ./bin/ar71xx/
  mkdir ./bin/ar71xx/builds
  mkdir ./bin/atheros/
  mkdir ./bin/atheros/builds
  echo " Initial set up completed. Continuing with build"
  echo ""
else
  echo "Build environment is configured. Continuing with build"
  echo ""
fi


#########################

echo "Start build process"

# Set up version strings
DIRVER="Ast-RC3d"
VER="SECN Version 2.0 "$DIRVER

###########################

echo "Copy files from Git repo into build folder"
rm -rf ./SECN-build/
cp -rp ~/Git/vt-firmware/SECN-build/ .
cp -fp ~/Git/vt-firmware/Build-scripts/FactoryRestore.sh  .

###########################

echo "Set up new directory name with date and version"
DATE=`date +%Y-%m-%d-%H:%M`
DIR=$DATE"-TP-"$DIRVER

###########################

# Set up build directory
echo "New build directory  ./bin/ar71xx/builds/build-"$DIR
mkdir ./bin/ar71xx/builds/build-$DIR

# Create md5sums file
touch ./bin/ar71xx/builds/build-$DIR/md5sums

###########################

echo '----------------------------'

echo "Set up .config for TL-WR842"
rm ./.config
cp ./SECN-build/WR842/config-WR842-Ast  ./.config
echo " Run defconfig"
make defconfig > /dev/null

# Get target device from .config file
TARGET=`cat .config | grep "CONFIG_TARGET" | grep "=y" | grep "_generic_" | cut -d _ -f 5 | cut -d = -f 1 `

echo "Check .config version"
cat ./.config | grep "OpenWrt version"
echo "Target:  " $TARGET

echo "Set up files for TL-WR842 "
rm -r ./files/*
echo "Copy generic files"
cp -r ./SECN-build/files  .
echo "Overlay device specific files"
cp -r ./SECN-build/WR842/files  . 

echo "Build Factory Restore tar file"
./FactoryRestore.sh

echo "Check files "
ls -al ./files   
echo ""

# Set up version file
echo "Version: "  $VER $TARGET
echo $VER  $TARGET               > ./files/etc/secn_version
echo "Date stamp the version file: " $DATE
echo "Build date " $DATE         >> ./files/etc/secn_version
echo " "                         >> ./files/etc/secn_version
 
echo "Check banner version"
cat ./files/etc/secn_version | grep "Version"
echo ""

echo "Run make for WR842"
make

echo  "Move files to build folder"
mv ./bin/ar71xx/*-squash*sysupgrade.bin ./bin/ar71xx/builds/build-$DIR
mv ./bin/ar71xx/*-squash*factory.bin    ./bin/ar71xx/builds/build-$DIR

echo "Clean up unused files"
rm ./bin/ar71xx/openwrt-*
echo "Update md5sums"
cat ./bin/ar71xx/md5sums | grep "squashfs" | grep ".bin" >> ./bin/ar71xx/builds/build-$DIR/md5sums
echo ""
echo "End WR842 build"
echo ""

##################
#exit  #  Uncomment to end the build process here

echo '----------------------------'

echo "Set up .config for TL-WDR4300, 4310, 3600"
rm ./.config
cp ./SECN-build/WDR4300/config-WDR4300-Ast  ./.config
echo " Run defconfig"
make defconfig > /dev/null

# Get target device from .config file
TARGET=`cat .config | grep "CONFIG_TARGET" | grep "=y" | grep "_generic_" | cut -d _ -f 5 | cut -d = -f 1 `

echo "Check .config version"
cat ./.config | grep "OpenWrt version"
echo "Target:  " $TARGET

echo "Set up files for TL-WDR4300 "
rm -r ./files/*
echo "Copy generic files"
cp -r ./SECN-build/files          .       ; 
echo "Overlay device specific files"
cp -r ./SECN-build/WDR4300/files  .       ; 

echo "Build Factory Restore tar file"
./FactoryRestore.sh			  ; 

echo "Check files "
ls -al ./files   
echo ""

# Set up version file
echo "Version: "  $VER $TARGET
echo $VER  $TARGET               > ./files/etc/secn_version
echo "Date stamp the version file: " $DATE
echo "Build date " $DATE         >> ./files/etc/secn_version
echo " "                         >> ./files/etc/secn_version
 
echo "Check banner version"
cat ./files/etc/secn_version | grep "Version"
echo ""

echo "Run make for WDR4300"
make

echo  "Move files to build folder"
mv ./bin/ar71xx/*wdr4300*squash*sysupgrade.bin ./bin/ar71xx/builds/build-$DIR
mv ./bin/ar71xx/*wdr4300*squash*factory.bin    ./bin/ar71xx/builds/build-$DIR
mv ./bin/ar71xx/*wdr4310*squash*sysupgrade.bin ./bin/ar71xx/builds/build-$DIR
mv ./bin/ar71xx/*wdr4310*squash*factory.bin    ./bin/ar71xx/builds/build-$DIR
mv ./bin/ar71xx/*wdr3600*squash*sysupgrade.bin ./bin/ar71xx/builds/build-$DIR
mv ./bin/ar71xx/*wdr3600*squash*factory.bin    ./bin/ar71xx/builds/build-$DIR


echo "Clean up unused files"
rm ./bin/ar71xx/openwrt-*
echo "Update md5sums"
cat ./bin/ar71xx/md5sums | grep "squashfs" | grep ".bin" >> ./bin/ar71xx/builds/build-$DIR/md5sums
echo ""
echo "End WDR4300 build"
echo ""

#################

echo '----------------------------'


echo " Build script complete"; echo " "


