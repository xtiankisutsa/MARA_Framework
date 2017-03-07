#!/bin/sh

if [ "$(uname)" = "Darwin" ] ; then
	# Update on Mac OS X platform  
	echo " I am a Mac"
	#sudo ./setup_mac.sh
else
	# Update on Linux
	echo "This is linux"
	#sudo ./setup.sh
fi

