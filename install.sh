#!/bin/bash
function usage() {
  cat << EOF
Usage: ./install.sh [FLAG]

This script install Arduino IDE v1.8.19 from official website and needed
libraries to perform the activities and challenges of Educational Robotics
Course, belonging to Mustakis Foundation's Science and Technology Program 

If you call the script without any flag, it will install Arduino IDE and
libraries.

The available flags are:
  -h (help)
  -i (IDE installation)
  -l (Libs installation, the character is a lowercase L)

You should ONLY PASS ONE FLAG AT TIME! (should I tell you why?)

EOF
  exit 1
}

function libInstallation() {
  case $OSTYPE in
    linux-gnu*)
      LIB_DIR=$HOME/Arduino/libraries/
      if [[ ! -d "${LIB_DIR}" ]]; then
        mkdir -p "${LIB_DIR}" 
      fi
      ;;
    darwin*)
      LIB_DIR=$HOME/Documents/Arduino/libraries/
      if [[ ! -d "${LIB_DIR}" ]]; then
        mkdir -p "${LIB_DIR}" 
      fi
      ;;
  esac
  wget https://raw.githubusercontent.com/pelafustan/robotics/master/{KnightRoboticsLibs_Iroh.tar.xz,NewPing.tar.xz,LiquidCrystal_I2C.tar.xz}
  tar xvf LiquidCrystal_I2C.tar.xz "${LIB_DIR}" 
  tar xvf KnightRoboticsLibs_Iroh_V3.5.tar.xz "${LIB_DIR}" 
  tar xvf NewPing.tar.xz "${LIB_DIR}" 
  rm *.tar.xz
}

# function to handle Arduino installation
function arduinoInstallation() {
  # check os
  case $OSTYPE in
    linux-gnu*)
      platform=linux
      ;;
    darwin*)
      platform=macos
      ;;
    *)
      platform=unknown
      ;;
  esac

  # do nothing if valid platform not found
  if [[ "${platform}" == unknown ]]
    exit 1
  fi

  WORK_DIR=$HOME/.arduino # folder for downloaded files
  if [[ ! -d "${WORK_DIR}" ]]; then
    mkdir -p "${WORK_DIR}" 
  else
    cd "${WORK_DIR}" 
  fi

  pkgver=1.8.19 # this must be updated manually

  case "${platform}" in
    linux)
      curl https://downloads.arduino.cc/arduino-"${pkgver}"-linux64.tar.xz --output arduino.tar.xz
      tar xvf arduino.tar.xz
      rm arduino.tar.xz
      user = $USER
      su -c './arduino-"${pkgver}"/install.sh'
      su -c 'usermod -a -G dialout "${user}"'
      echo -e "\nAhora, para que los cambios surtan efecto, cierre sesión por favor...\n"
      read -p "Presione 1 para cerrar sesión automáticamente 2 para hacerlo manualmente después: " foo
      if [[ "{$foo}" == 1 ]]; then
        echo "En 30 segundos se cerrará sesión. Guarde todo su trabajo."
        sleep 30
        pkill -KILL -u $USER
      else
        exit 0
      fi
      ;;
    macos)
      curl https://downloads.arduino.cc/arduino-"${pkgver}"-macosx.zip --output arduino.zip
      unzip -qq arduino.zip
      mv Arduino.app /Applications/Arduino.app 
      exit 0
      ;;
  esac
}

if [[ $# -eq 0 ]]; then
  arduinoInstallation
  libInstallation
elif [[ $# -eq 1 ]]
  while getopts 'hil:' flag; do
    case "${flag}" in
      h)
        usage
        ;;
      i)
        arduinoInstallation
        ;;
      l)
        libInstallation
        ;;
      *)
        usage
        ;;
    esac
  done
else
  usage
fi

