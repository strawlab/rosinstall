#!/bin/bash -x
set -e

if [ ! "$ROS_TARGET" ] ; then export ROS_TARGET=$HOME/ros.electric.boost1.46 ; fi
if [ ! "$FLYCAVE_TARGET" ] ; then export FLYCAVE_TARGET=$HOME/ros-flycave.electric.boost1.46 ; fi

rosinstall --nobuild $FLYCAVE_TARGET $ROS_TARGET https://raw.github.com/strawlab/rosinstall/master/strawlab-electric-flycave-git.rosinstall

source $FLYCAVE_TARGET/setup.bash
cd $FLYCAVE_TARGET

# Now parse our rosdeps and tell ubuntu to install all the packages.
wget https://raw.github.com/strawlab/rosinstall/master/scripts/parse_rosdep -O parse_rosdep
chmod a+x parse_rosdep

STACKS=`python -c "import yaml; print ' '.join([x['git']['local-name'] for x in yaml.safe_load(open('${FLYCAVE_TARGET}/.rosinstall').read()) if x.has_key('git')]);"`

# Figure out what packages we need to apt-get and install them -----------------
rosdep generate_bash $STACKS > rosdep.output || true
cat rosdep.output | ./parse_rosdep > to_install.txt
read DEPS < to_install.txt
sudo apt-get --yes install $DEPS

# Build everything -------------------------------------------------------------
rosmake --robust $STACKS
