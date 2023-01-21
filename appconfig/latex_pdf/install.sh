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

default=n
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

    sudo apt -y install texlive texlive-latex-extra texlive-lang-portuguese  \
    texlive-science texlive-pstricks latexmk texmaker texlive-font-utils  \
    texlive-fonts-extra texlive-bibtex-extra biber okular pdf-presenter-console \
    dvipng sketch

    sudo apt -y install pdftk
    
    # use in pdfpc to play videos
    sudo apt -y install gstreamer1.0-libav

    # install prerequisities
    sudo apt -y install valac libgee-0.8-dev libpoppler-glib-dev \
    libgtk-3-dev libjson-glib-dev libmarkdown2-dev libwebkit2gtk-4.0-dev libsoup2.4-dev \
    libqrencode-dev gstreamer1.0-gtk3

    # compile and install pdfpc
    cd $APP_PATH/../../submodules/latex_pdf/
    [ ! -e build ] && mkdir build
    cd build
    cmake ..
    make
    sudo make install

    break
  elif [[ $response =~ ^(n|N)=$ ]]
  then
    break
  else
    echo " What? \"$resp\" is not a correct answer. Try y+Enter."
  fi
done
