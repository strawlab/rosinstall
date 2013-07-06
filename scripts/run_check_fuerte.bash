#!/bin/bash
set -e

# Run the check_ros.bash script. For example, to run in a pbuilder:
#  pbuilder-precise-amd64 execute run_check_fuerte.bash

RELEASE=fuerte

mkdir -p $HOME
apt-get install --yes sudo wget
wget http://strawlab.org/rosinstall/scripts/${RELEASE}_check_ros.bash -O ${RELEASE}_check_ros.bash
chmod a+x ${RELEASE}_check_ros.bash
./${RELEASE}_check_ros.bash
