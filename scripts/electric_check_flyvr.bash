#!/bin/bash -x
set -e

if [ ! "$ROS_TARGET" ] ; then export ROS_TARGET=$HOME/ros.electric.boost1.46 ; fi
if [ ! "$FLYVR_TARGET" ] ; then export FLYVR_TARGET=$HOME/ros-flyvr.electric.boost1.46 ; fi

rosinstall --nobuild $FLYVR_TARGET $ROS_TARGET https://raw.github.com/strawlab/rosinstall/master/strawlab-electric-flyvr.rosinstall

source $FLYVR_TARGET/setup.bash
cd $FLYVR_TARGET

# Now parse our rosdeps and tell ubuntu to install all the packages.
wget https://raw.github.com/strawlab/rosinstall/master/scripts/parse_rosdep -O parse_rosdep
chmod a+x parse_rosdep

STACKS="joystick_drivers flyvr browser_joystick camera_model rosgobject"

# Figure out what packages we need to apt-get and install them -----------------
rosdep generate_bash $STACKS > rosdep.output || true
cat rosdep.output | ./parse_rosdep > to_install.txt
read DEPS < to_install.txt
sudo apt-get --yes install $DEPS

# Build everything -------------------------------------------------------------
rosmake --robust $STACKS
