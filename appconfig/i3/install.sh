#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
for param in "$@"
do
  echo $param
  if [ $param="--unattended" ]; then
    echo "installing in unattended mode"
    unattended=1
    subinstall_params="--unattended"
  fi
done

default=y
while true; do
  if [[ "$unattended" == "1" ]]
  then
    resp=$default
  else
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall i3? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt-get -y install libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev

    sudo apt-get -y install libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev
    
    sudo apt-get -y install libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev

    sudo apt-get -y install autoconf libxcb-xrm0 libxcb-xrm-dev automake libxcb-shape0-dev dunst libkeybinder-3.0-0

    # required for i3-layout-manager
    sudo apt-get -y install jq rofi xdotool x11-xserver-utils indent libanyevent-i3-perl

    # Tiago add
    sudo apt-get -y install meson polybar compton imagemagick feh konsole asciidoc
    pip install pywal

    if [ "$unattended" == "0" ] && [ -z $TRAVIS ]; # if running interactively
    then
      # install graphical X11 graphical backend with lightdm loading screen
      echo ""
      echo "-----------------------------------------------------------------"
      echo "Installing lightdm login manager. It might require manual action."
      echo "-----------------------------------------------------------------"
      echo "If so, please select \"lightdm\", after hitting Enter"
      echo ""
      echo "Waiting for Enter..."
      echo ""
      read
    fi

    sudo apt-get -y install lightdm

    # compile i3 dependency which is not present in the repo
    sudo apt-get -y install xutils-dev

    cd /tmp
    [ -e xcb-util-xrm ] && sudo rm -rf /tmp/xcb-util-xrm
    git clone https://github.com/Airblader/xcb-util-xrm
    cd xcb-util-xrm
    git submodule update --init
    sudo ./autogen.sh --prefix=/usr
    sudo make
    sudo make install

    # install light for display backlight control
    # compile i3
    sudo apt-get -y install help2man

    cd $APP_PATH/../../submodules/light/
    sudo ./autogen.sh
    sudo ./configure && sudo make
    sudo make install
    # set the minimal backlight value to 5%
    sudo light -N 5
    # clean up after the compilation
    sudo make clean
    git clean -fd

    toilet Installing i3

    # compile i3
    cd $APP_PATH/../../submodules/i3/
    # autoreconf --force --install
    sudo meson -Ddocs=true -Dmans=true ../build
    sudo meson compile -C ../build
    sudo meson install -C ../build

    # rm -rf build/
    # mkdir -p build && cd build/

    # Disabling sanitizers is important for release versions!
    # The prefix and sysconfdir are, obviously, dependent on the distribution.
    # ../configure --prefix=/usr --sysconfdir=/etc --disable-sanitizers
    # make
    # sudo make install

    # clean after myself
    git reset --hard
    git clean -fd

    # compile i3 blocks
    cd $APP_PATH/../../submodules/i3blocks/
    sudo ./autogen.sh
    sudo ./configure
    sudo make
    sudo make install

    # clean after myself
    git reset --hard
    git clean -fd

    toilet Compiling i3blocks

    # for cpu usage in i3blocks
    sudo apt-get -y install sysstat

    # for brightness and volume control
    sudo apt-get -y install xbacklight alsa-utils pulseaudio feh arandr

    arch=$( uname -i )
    if [ "$arch" != "aarch64" ]; then
      sudo apt-get -y install acpi
    fi

    # for making gtk look better
    sudo apt-get -y install lxappearance

    # symlink settings folder
    if [ ! -e ~/.i3 ]; then
      sudo ln -sf $APP_PATH/doti3 ~/.i3
    fi

    # copy i3 config file
    sudo cp $APP_PATH/doti3/config_git ~/.i3/config
    sudo cp $APP_PATH/doti3/i3blocks.conf_git ~/.i3/i3blocks.conf
    sudo cp $APP_PATH/i3blocks/wifi_git $APP_PATH/i3blocks/wifi
    sudo cp $APP_PATH/i3blocks/battery_git $APP_PATH/i3blocks/battery

    # copy fonts
    # fontawesome 4.7
    sudo mkdir -p ~/.fonts
    sudo cp $APP_PATH/fonts/* ~/.fonts/

    # link fonts.conf file
    sudo mkdir -p ~/.config/fontconfig
    sudo ln -sf $APP_PATH/fonts.conf ~/.config/fontconfig/fonts.conf

    # install useful gui utils
    sudo apt-get -y install thunar rofi compton systemd

    $APP_PATH/make_launchers.sh $APP_PATH/../../scripts

    # disable nautilus
    sudo gsettings set org.gnome.desktop.background show-desktop-icons false

    # install xkb layout state
    cd $APP_PATH/../../submodules/xkblayout-state/
    sudo make
    sudo ln -sf $APP_PATH/../../submodules/xkblayout-state/xkblayout-state /usr/bin/xkblayout-state

    sudo apt-get -y install i3lock

    # install prime-select (for switching gpus)
    # sudo apt-get -y install nvidia-prime

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi

done
