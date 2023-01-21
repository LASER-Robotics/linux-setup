#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

toilet Installing ROS2

distro=`lsb_release -r | awk '{ print $2 }'`
[ "$distro" = "22.04" ] && ROS_DISTRO="humble"

debian=`lsb_release -d | grep -i debian | wc -l`
[[ "$debian" -eq "1" ]] && ROS_DISTRO="humble"

# Set locale
sudo apt update && sudo apt install locales
sudo locale-gen en_US en_US.UTF-8
sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
export LANG=en_US.UTF-8

# ensure that the Ubuntu Universe repository is enabled.
sudo apt install software-properties-common
sudo add-apt-repository universe

# add the ROS 2 GPG key with apt
sudo apt update && sudo apt install curl
sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key -o /usr/share/keyrings/ros-archive-keyring.gpg


# add the repository to the sources list.
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(. /etc/os-release && echo $UBUNTU_CODENAME) main" | sudo tee /etc/apt/sources.list.d/ros2.list > /dev/null

sudo apt update
sudo apt upgrade

# Desktop Install (Recommended): ROS, RViz, demos, tutorials.
sudo apt install ros-humble-desktop

# Development tools: Compilers and other tools to build ROS packages
sudo apt install ros-dev-tools

num=`cat ~/.bashrc | grep "/opt/ros/$ROS_DISTRO/setup.bash" | wc -l`
if [ "$num" -lt "1" ]; then

  # set bashrc
  echo "
source /opt/ros/$ROS_DISTRO/setup.bash" >> ~/.bashrc

fi