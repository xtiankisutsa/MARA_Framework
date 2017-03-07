#!/bin/bash

#These are the requirements for running this tool:

#Package update
brew update -y -v
sudo pip install --upgrade pip

#Java JDK
brew tap caskroom/cask -y -v
brew tap caskroom/versions -y -v
brew cask install java -y

#Git
brew install git -y -v

#Tree
brew install tree -y -v

#Figlet
brew install figlet -y -v

#unrest
sudo pip install unirest

#aha - Ansi HTML Adapter
#sudo apt-get -y install aha
brew install aha -y -v

#Python3
brew install python3 -y -v

#Androwarn dependencies
sudo pip install Jinja2 

#Smali graph generation dependency
sudo pip install pydot

#configparser
sudo pip install configparser

#Smalisca
sudo pip install smalisca

#APKiD
cd tools/
git clone https://github.com/rednaga/yara-python
sudo python setup.py install
sudo pip install apkid
cd ../../

#Increase maximum java heap size for Jadx
export JAVA_OPTS="-Xmx4G"
source ~/.bashrc


