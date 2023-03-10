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
    [[ -t 0 ]] && { read -t 10 -n 2 -p $'\e[1;32mSet up for Latex development? [y/n] (default: '"$default"$')\e[0m\n' resp || resp=$default ; }
  fi
  response=`echo $resp | sed -r 's/(.*)$/\1=/'`

  if [[ $response =~ ^(y|Y)=$ ]]
  then

    sudo apt -y install texlive texlive-latex-extra texlive-lang-portuguese
    sudo apt -y install texlive-science texlive-pstricks latexmk texmaker texlive-font-utils
    sudo apt -y install texlive-fonts-extra texlive-bibtex-extra biber okular 
    sudo apt -y install pdf-presenter-console dvipng sketch

    sudo apt -y install pdftk
    
    # use in pdfpc to play videos
    sudo apt -y install gstreamer1.0-libav

    #PDF Arranger
    sudo add-apt-repository ppa:linuxuprising/apps

    sudo apt update

    sudo apt -y install pdfarranger

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
