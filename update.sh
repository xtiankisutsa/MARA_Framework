#!/bin/bash

bold=`tput bold`
normal=`tput sgr0`
red='\e[0;31m'
yellow='\e[1;33m'
blue='\e[1;34m'
light_green='\e[1;32m'
light_cyan='\e[1;36m'
cyan='\e[0;36m'  
red='\e[0;31m'
light_red='\e[1;31m'     
brown='\e[0;33m'
no_color='\e[0m'

mkdir -p update/
cd update/

echo -e "${no_color}${brown}Downloading the latest version of MARA${no_color}"
git clone https://github.com/xtiankisutsa/MARA_Framework
cd ..
echo " "

echo -e "${no_color}${brown}Replacing the local files${no_color}"
mv tools/ tools_old
mv documentation/ documentation_old

mv update/MARA_Framework/* .
echo " "

echo -e "${no_color}${brown}Updating MARA dependencies${no_color}"

if [ "$(uname)" = "Darwin" ] ; then
	# Update on Mac OS X platform  
	sudo ./setup_mac.sh
else
	# Update on Linux
	sudo ./setup.sh
fi
echo " "

echo -e "${no_color}${brown}Cleaning up...${no_color}"
rm -r documentation_old/
rm -r tools_old/
rm -r update/
chown -R $USER:$USER *
echo " "

echo -e "${no_color}${brown}Update completed...!!${no_color}"

exit
