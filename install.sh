#!/bin/bash

# get the path to this script
MY_PATH=`dirname "$0"`
MY_PATH=`( cd "$MY_PATH" && pwd )`

# define paths
APPCONFIG_PATH=$MY_PATH/appconfig

cd $MY_PATH
git pull
git submodule update --init --recursive

# install packages
sudo apt-get -y update

subinstall_params=""
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

var1="18.04"
var2=`lsb_release -r | awk '{ print $2 }'`
[ "$var2" = "$var1" ] && export BEAVER=1

if [ -n "$BEAVER" ]; then
  sudo apt -y install python-git
else
  sudo apt -y install python3-git
fi

sudo apt -y install cmake cmake-curses-gui ruby git sl htop indicator-multiload figlet toilet gem ruby build-essential tree exuberant-ctags libtool automake autoconf autogen libncurses5-dev python2.7-dev python3-dev libc++-dev openssh-server xclip xsel vlc pkg-config python-setuptools python3-setuptools ffmpeg sketch xserver-xorg-video-intel silversearcher-ag exfat-fuse exfat-utils xserver-xorg-input-synaptics python3-pip blueman gimp autossh jq okular dvipng okular xvfb gparted net-tools espeak pdfpc xserver-xorg-input-all

if [ "$unattended" == "0" ]
then
  if [ "$?" != "0" ]; then echo "Press Enter to continues.."; read; fi
fi

# install TMUX
bash $APPCONFIG_PATH/tmux/install.sh $subinstall_params

# setup RANGER
bash $APPCONFIG_PATH/ranger/install.sh $subinstall_params

# install VIM
bash $APPCONFIG_PATH/vim/install.sh $subinstall_params

# install URXVT
bash $APPCONFIG_PATH/urxvt/install.sh $subinstall_params

# install FONTS POWERLINE
bash $APPCONFIG_PATH/fonts-powerline/install.sh $subinstall_params

# install NVIM
bash $APPCONFIG_PATH/nvim/install.sh $subinstall_params

# install ZSH with ATHAME
bash $APPCONFIG_PATH/zsh/install.sh $subinstall_params

# install I3
bash $APPCONFIG_PATH/i3/install.sh $subinstall_params

# install LATEX support
bash $APPCONFIG_PATH/latex/install.sh $subinstall_params

# install PDFTK
bash $APPCONFIG_PATH/pdftk/install.sh $subinstall_params

# install PANDOC
bash $APPCONFIG_PATH/pandoc/install.sh $subinstall_params

# install SHUTTER
bash $APPCONFIG_PATH/pandoc/install.sh $subinstall_params

# install ZATHURA
bash $APPCONFIG_PATH/zathura/install.sh $subinstall_params

# install VIMIV
bash $APPCONFIG_PATH/vimiv/install.sh $subinstall_params

# install SILVER SEARCHER (ag)
bash $APPCONFIG_PATH/silver_searcher/install.sh $subinstall_params

# setup modified keyboard rules
bash $APPCONFIG_PATH/keyboard/install.sh $subinstall_params

# install PLAYERCTL
bash $APPCONFIG_PATH/playerctl/install.sh $subinstall_params

# install PAPIS
bash $APPCONFIG_PATH/papis/install.sh $subinstall_params

# install GRUB CUSTOMIZER
bash $APPCONFIG_PATH/grub-customizer/install.sh $subinstall_params

# install TMUXINATOR
bash $APPCONFIG_PATH/tmuxinator/install.sh $subinstall_params

#############################################
# remove the interactivity check from bashrc
#############################################

if [ -x "$(whereis nvim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis nvim | awk '{print $2}')"
  HEADLESS="--headless"
elif [ -x "$(whereis vim | awk '{print $2}')" ]; then
  VIM_BIN="$(whereis vim | awk '{print $2}')"
  HEADLESS=""
fi

$VIM_BIN $HEADLESS -E -s -c "%g/running interactively/norm dap" -c "wqa" -- ~/.bashrc

#############################################
# adding GIT_PATH variable to .bashrc
#############################################

# add variable for path to the git repository
num=`cat ~/.bashrc | grep "GIT_PATH" | wc -l`
if [ "$num" -lt "1" ]; then

  TEMP=`( cd "$MY_PATH/../" && pwd )`

  echo "Adding GIT_PATH variable to .bashrc"
  # set bashrc
  echo "
# path to the git root
export GIT_PATH=$TEMP" >> ~/.bashrc
fi

#############################################
# add tmux sourcing of dotbashrd to .bashrc
#############################################

num=`cat ~/.bashrc | grep "RUN_TMUX" | wc -l`
if [ "$num" -lt "1" ]; then

  default=y
  while true; do
    if [[ "$unattended" == "1" ]]
    then
      resp=$default
    else
      [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mDo you want to run TMUX automatically with every terminal? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
    fi
    response=`echo $resp | sed -r 's/(.*)$/\1=/'`

    if [[ $response =~ ^(y|Y)=$ ]]
    then

      echo "
# want to run tmux automatically with new terminal?
export RUN_TMUX=true" >> ~/.bashrc

      echo "Setting variable RUN_TMUX to true"

      break
    elif [[ $response =~ ^(n|N)=$ ]]
    then

      echo "
# want to run tmux automatically with new terminal?
export RUN_TMUX=false" >> ~/.bashrc

      echo "Setting variable RUN_TMUX to false"

      break
    else
      echo " What? \"$resp\" is not a correct answer. Try y+Enter."
    fi
  done
fi

##################################################
# install inputs libraries when they are missing
##################################################
sudo apt -y install xserver-xorg-input-all

#############################################
# Disable automatic update over apt
#############################################

sudo systemctl disable apt-daily.service
sudo systemctl disable apt-daily.timer

sudo systemctl disable apt-daily-upgrade.timer
sudo systemctl disable apt-daily-upgrade.service

#############################################
# link the scripts folder
#############################################

if [ ! -e ~/.scripts ]; then
  ln -sf $MY_PATH/scripts ~/.scripts
fi

#############################################
# add PROFILES variables
#############################################

num=`cat ~/.bashrc | grep "PROFILES_BOTH" | wc -l`
if [ "$num" -lt "1" ]; then

  echo "Adding epigen rules to .bashrc"
  echo '
# profiling options for EPIGEN
export PROFILES_BOTH="COLORSCHEME_DARK"' >> ~/.bashrc

fi

#############################################
# creating .vimpath file
#############################################

# path for ctags
# path for file search

#############################################
# add sourcing of dotbashrd to .bashrc
#############################################
num=`cat ~/.bashrc | grep "dotbashrc" | wc -l`
if [ "$num" -lt "1" ]; then

  echo "Adding source to .bashrc"
  # set bashrc
  echo "
# source Tomas's Linux Setup
source $APPCONFIG_PATH/bash/dotbashrc" >> ~/.bashrc

fi

# deploy configs by Profile manager
./deploy_configs.sh

# finally source the correct rc file
toilet All Done

# say some tips to the new user
echo "Huray, the 'Linux Setup' should be ready, try opening new terminal."
