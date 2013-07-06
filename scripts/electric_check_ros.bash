#!/bin/bash -x
set -e

# DESCRIPTION -----------------------------------------------------------------

# This script will go from a bare system to a system with a ROS build
# in the directory specified by $TARGET.

# PREREQUISITES: universe multiverse repositories installed

# VARIABLES -------------------------------------------------------------------

# the directory to build
if [ ! "$ROS_TARGET" ] ; then export ROS_TARGET=$HOME/ros.electric.boost1.46 ; fi

# Get the dependencies needed for this script ----------------------------------
sudo apt-get --yes install python-rosinstall git wget build-essential

# Let rosinstall do its downloading of the various stacks  ---------------------
rosinstall --nobuild $ROS_TARGET http://strawlab.org/rosinstall/strawlab-electric-desktop-full.rosinstall

# Add ROS to the path, get a utility function ----------------------------------
source $ROS_TARGET/setup.bash
cd $ROS_TARGET
wget http://strawlab.org/rosinstall/scripts/parse_rosdep -O parse_rosdep
chmod a+x parse_rosdep

# Now, make the rospack package (first step to bootstrapping) ------------------
rosmake rospack

# Read the names of all the stacks we just downloaded --------------------------
rosstack list-names | python -c "import sys; print ' '.join(sys.stdin.read().split())" > ros_stacks.txt
read STACKS < ros_stacks.txt

# Figure out what packages we need to apt-get and install them -----------------
rosdep generate_bash $STACKS > rosdep.output || true
cat rosdep.output | ./parse_rosdep > to_install.txt
read DEPS < to_install.txt
sudo apt-get --yes install $DEPS

# Build everything -------------------------------------------------------------
rosmake --robust $STACKS
