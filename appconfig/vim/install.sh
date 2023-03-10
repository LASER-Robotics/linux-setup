#!/bin/bash

set -e

trap 'last_command=$current_command; current_command=$BASH_COMMAND' DEBUG
trap 'echo "$0: \"${last_command}\" command failed with exit code $?"' ERR

# get the path to this script
APP_PATH=`dirname "$0"`
APP_PATH=`( cd "$APP_PATH" && pwd )`

unattended=0
subinstall_params=""
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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mInstall vim? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    toilet Setting up vim  #print the text only

    sudo apt-get -y remove vim vim-* || echo ""

    sudo apt-get -y install libgtk2.0-dev libatk1.0-dev libcairo2-dev libx11-dev libxpm-dev libxt-dev python3-dev clang-format libncursesw5-dev ruby-dev

    sudo -H pip3 install rospkg

    sudo apt-get install vim

    sudo curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

    # set vim as a default git mergetool
    sudo git config --global merge.tool vimdiff

    # symlink vim settings
    sudo rm -rf ~/.vim
    ln -fs $APP_PATH/dotvim ~/.vim 

    # updated new plugins and clean old plugins
    sudo /usr/bin/vim -E -c "let g:user_mode=1" -c "so $APP_PATH/dotvimrc" -c "PlugInstall" -c "wqa" || echo "It normally returns >0"

    if [ "$unattended" == "0" ] && [ -z $TRAVIS ]; # if running interactively
    then
      # Stopping to Debug the vim and plugins installation
      echo ""
      echo "-----------------------------------------------------------------"
      echo "To debug."
      echo "-----------------------------------------------------------------"
      echo ""
      echo "Waiting for Enter..."
      echo ""
      read
    fi


    default=y
    while true; do
      if [[ "$unattended" == "1" ]]
      then
        resp=$default
      else
        [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mCompile YouCompleteMe? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
      fi
      response=`echo $resp | sed -r 's/(.*)$/\1=/'`

      if [[ $response =~ ^(y|Y)=$ ]]
      then

        # set youcompleteme
        toilet Setting up youcompleteme

        # if 22.04, just install python3-clang from apt
        sudo apt -y install python3-clang
        
        # install prequisites for YCM
        sudo apt -y install clangd-12

        # set clangd to version 12 by default
        sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-12 100
        sudo apt -y install libboost-all-dev


        # TIAGO
        sudo apt update

        sudo apt -y install vim-youcompleteme

        # link .ycm_extra_conf.py
        ln -fs $APP_PATH/dotycm_extra_conf.py ~/.ycm_extra_conf.py

        break
      elif [[ $response =~ ^(n|N)=$ ]]
      then
        break
      else
        echo " What? \"$resp\" is not a correct answer. Try y+Enter."
      fi
    done

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
