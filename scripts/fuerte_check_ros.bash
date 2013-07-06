#!/bin/bash -x
set -e

# DESCRIPTION -----------------------------------------------------------------

# This script will go from a bare system to a system with a ROS build
# in the directory specified by $TARGET.

# PREREQUISITES: universe multiverse repositories installed

# VARIABLES -------------------------------------------------------------------

# the directory to build
if [ ! "$ROS_TARGET" ] ; then export ROS_TARGET=$HOME/ros.fuerte.boost1.46 ; fi

# Get the dependencies needed for this script ----------------------------------
sudo apt-get --yes install python-rosinstall python-rosdep git wget \
python-empy python-nose swig libboost-all-dev liblog4cxx10-dev \
libapr1-dev libaprutil1-dev libbz2-dev python-dev libgtest-dev python-paramiko \
pkg-config python-setuptools build-essential

sudo apt-get --yes install python-wxgtk2.8 python-gtk2 python-matplotlib \
libwxgtk2.8-dev python-imaging libqt4-dev graphviz qt4-qmake python-numpy

# Let rosinstall do its downloading of the various stacks  ---------------------
rosinstall --catkin ${TARGET}BUILD http://strawlab.org/rosinstall/strawlab-fuerte-desktop-full.rosinstall

# Add ROS to the path, get a utility function ----------------------------------
cd ${TARGET}BUILD

mkdir -p build
cd build

cmake .. -DCMAKE_INSTALL_PREFIX=${TARGET}
make -j8
make install
