#!/bin/bash
set -e

# Run the check_ros.bash script. For example, to run in a pbuilder:
#  pbuilder-precise-amd64 execute run_check_electric.bash

mkdir -p $HOME
apt-get install --yes sudo wget
wget http://strawlab.org/rosinstall/scripts/electric_check_ros.bash -O electric_check_ros.bash
chmod a+x electric_check_ros.bash
./electric_check_ros.bash
