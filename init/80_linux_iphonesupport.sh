#!/bin/bash

is_linux || return 1

sudo apt-get install build-essential automake cmake libreadline6 autotools-dev libcurl4-openssl-dev autoconf libplist3 libplist-utils libplist-dev libplist++-dev libzip-dev git curl libgnutls-dev libreadline-dev libusb-dev libtool libusb-1.0-0-dev libusbmuxd-dev libglib2.0-dev libimobiledevice-dev

mkdir idevicerestore
cd idevicerestore
git clone http://git.sukimashita.com/libirecovery.git
#libimobiledevice
cd libirecovery
./autogen.sh
make && sudo make install
cd ../

git clone git@github.com:libimobiledevice/idevicerestore.git
cd idevicerestore
./autogen.sh
make && sudo make install
sudo ldconfig
cd ../

git clone http://github.com/posixninja/ideviceactivate.git
cd ideviceactivate
make && sudo make install