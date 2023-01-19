#!/bin/bash

set -e

distro=`lsb_release -r | awk '{ print $2 }'`
[ "$distro" = "22.04" ] && ROS_DISTRO="humble"

sudo apt -y install git

echo "running the main install.sh"

./install.sh --unattended

echo "install part ended"
