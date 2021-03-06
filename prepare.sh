#!/bin/bash

# Exit script if any command fails
set -e 
set -o pipefail

if [ $# -ne 0 ]
  then
    echo "Usage: prepare.sh"
    exit 1
fi

# Essential Dependencies
echo "Installing Essential dependencies..."

# If we're not on 18.04
sudo apt-get -y update

if [[ `lsb_release -rs` != "18.04" ]]
  then   
    echo "Adding ppa:ubuntu-toolchain-r/test apt-repository "
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test -y
    sudo apt-get -y update
fi

sudo apt-get -y install build-essential
sudo apt-get -y install gcc-8 g++-8

# Ubuntu 16.04 does not have newest CMake so need to build it manually
if [[ `lsb_release -rs` != "18.04" ]]; then   
  sudo apt-get --purge remove cmake-qt-gui -y
  sudo apt-get --purge remove cmake -y
  mkdir -p cmake_tmp
  cd cmake_tmp
  #wget https://cmake.org/files/v3.10/cmake-3.10.1.tar.gz
  #tar -xzvf cmake-3.10.1.tar.gz
  #cd cmake-3.10.1/
  #--> switching to cmake 3.15 for python3
  wget https://cmake.org/files/v3.15/cmake-3.15.0.tar.gz
  tar -xzvf cmake-3.15.0.tar.gz
  cd cmake-3.15.0/
  ./bootstrap
  make -j4
  sudo make install
  cd ../..
  sudo rm -r cmake_tmp
else
  sudo apt-get -y install cmake
fi

sudo apt-get -y install zip
sudo apt-get -y install libopenblas-dev liblapack-dev
sudo apt-get -y install libgtk2.0-dev pkg-config libavcodec-dev libavformat-dev
sudo apt-get -y install libtbb2 libjpeg-dev libpng-dev libtiff-dev libdc1394-22-dev
sudo apt-get -y install python3-dev python3-dev python3-pip python3-tk python3-lxml python3-six
echo "######## Essential dependencies installed."

# Install boost 1.71.0
echo "######## Downloading Boost..."
wget https://dl.bintray.com/boostorg/release/1.71.0/source/boost_1_71_0.tar.bz2
tar xf boost_1_71_0.tar.bz2
rm -r boost_1_71_0.tar.bz2
echo "######## Boost ready."

# OpenCV Dependency
echo "######## Downloading OpenCV..."
wget https://github.com/opencv/opencv/archive/4.1.0.zip
unzip 4.1.0.zip
rm -r 4.1.0.zip
echo "######## OpenCV ready."

# dlib dependecy
echo "######## Downloading dlib"
wget http://dlib.net/files/dlib-19.13.tar.bz2;
tar xf dlib-19.13.tar.bz2;
rm -r dlib-19.13.tar.bz2
echo "######## dlib ready"