#!/bin/bash

# Creación carpeta en donde se descargará Arduino IDE y librerías necesarias.
WORK_DIR=$HOME/.arduino
if [[ ! -d $WORK_DIR ]]; then
	mkdir -p $WORK_DIR
	cd $WORK_DIR
else
	cd $WORK_DIR
fi

# Descarga de Arduino IDE y librerías.
wget https://downloads.arduino.cc/arduino-1.8.19-linux64.tar.xz
wget https://raw.githubusercontent.com/pelafustan/robotics/master/{KnightRoboticsLibs_Iroh.tar.xz,NewPing.tar.xz,LiquidCrystal_I2C.tar.xz}

# Instalación Arduino IDE
tar -xvf 'arduino-1.8.19-linux64.tar.xz'
USER_A=$USER
su -c "./arduino-1.8.19/install.sh"
su -c "usermod -a -G dialout $USER_A"

# Instalación de librerías.
LIB_DIR="$HOME/Arduino/libraries/"
if [[ ! -d $LIB_DIR ]]; then
       	mkdir -p $LIB_DIR
        tar xvf LiquidCrystal_I2C.tar.xz $LIB_DIR
       	tar xvf KnightRoboticsLibs_Iroh_V3.5.tar.xz $LIB_DIR
       	tar xvf NewPing.tar.xz $LIB_DIR
else
	tar xvf LiquidCrystal_I2C.tar.xz -d $LIB_DIR
	tar xvf KnightRoboticLibs_Iroh_V3.5.tar.xz $LIB_DIR
	tar xvf NewPing.tar.xz $LIB_DIR
fi

rm arduino-1.8.19-linux64.tar.xz KnightRoboticsLibs_Iroh_V3.5.tar.xz LiquidCrystal_I2C.tar.xz NewPing.rar.tar.xz

echo -e "\nAhora, para que los cambios surtan efecto, cierre sesión por favor...\n"
read -p "Presione 1 para cerrar sesión automáticamente 2 para hacerlo manualmente después: " foo
if [[ $foo == 1 ]]; then
	echo "En 30 segundos se cerrará sesión. Guarde todo su trabajo."
	sleep 30
	pkill -KILL -u $USER
else
	exit 0
fi
