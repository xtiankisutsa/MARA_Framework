#!/usr/bin/env bash

#These are the requirements for running this tool:

chmod +x *.sh

declare -a brew_packages
declare -a pip3_packages
declare -a cleanup_dirs

## Brew ##

# Update brew and all formulas
brew update -v

brew_packages=(python python3 bash gnu-sed git tree figlet aha)
# Sed will replace your BSD sed with GNU sed
#aha - Ansi HTML Adapter

for package in "${brew_packages[@]}"; do
	brew install "${package}"
done

#Java JDK
brew tap caskroom/cask -v
brew tap caskroom/versions -v
brew cask install java 

## Pip ##

pip3_packages=(Jinja2 pydot configparser smalisca trueseeing)
# Jinja2 - Androwarn dependencies
# pydot - Smali graph generation dependency

# Install pip3
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# sudo -H python get-pip.py
sudo -H python3 get-pip.py
rm get-pip.py

# Upgrade pip
sudo -H pip install --upgrade pip
sudo -H pip3 install --upgrade pip

# unrest
sudo -H pip2 install unirest

for package in "${pip3_packages[@]}"; do
	sudo -H pip3 install "${package}"
done

#APKiD
(
	# Do this in a sub shell 
	# so we don't need to cd back into the top level MARA dir
	cd tools/ || exit
	git clone --recursive https://github.com/rednaga/yara-python-1 yara-python
	cd yara-python/ || exit
	sudo -H python setup.py build --enable-dex install
	sudo -H pip2 install apkid
)

#whatweb
# sudo apt-get install -y whatweb


#Increase maximum java heap size for Jadx
echo "export JAVA_OPTS='-Xmx4G'" >> ~/.bashrc
source ~/.bashrc

#make tools executable
chmod -R +x tools/

#Clean up
cleanup_dirs=(documentation_old tools_old update)

for dir in "${cleanup_dirs[@]}"; do
	if [[ -d "${dir}" ]]; then
		rm -rf "{dir:?}"
	fi
done

exit 0
