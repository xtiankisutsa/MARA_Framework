#!/usr/bin/env bash

#These are the requirements for running this tool:

#Package update
sudo apt-get update

#Install python
sudo apt-get install build-essential libssl-dev libffi-dev python-dev python-pip python3-dev python3-pip

#Upgrade pip
sudo pip install --upgrade pip
sudo pip3 install --upgrade pip

#Python-pip
sudo apt-get -y install python-pip

#Java JDK
sudo apt-get -y install openjdk-8-jdk

#Git
sudo apt-get -y install git

#Tree
sudo apt-get -y install tree

#install libs
sudo dpkg --add-architecture i386
sudo apt-get -y install libgtk2.0-0:i386 libxxf86vm1:i386 libsm6:i386 libstdc++6:i386 lib32z1 

#Figlet
sudo apt-get -y install figlet

#unrest
sudo pip install unirest

#aha - Ansi HTML Adapter
sudo apt-get -y install aha

#Python3
sudo apt-get -y install python3

#Androwarn dependencies
sudo apt-get -y install python python-jinja2 git

#Smali graph generation dependency
sudo pip install pydot --user

#configparser
sudo pip install configparser

#Smalisca
sudo pip install smalisca

#APKiD
sudo pip install wheel
sudo pip wheel --wheel-dir=/tmp/yara-python --build-option="build" --build-option="--enable-dex" git+https://github.com/VirusTotal/yara-python.git@v3.10.0
sudo pip install --no-index --find-links=/tmp/yara-python yara-python
sudo pip install apkid

#whatweb
sudo apt-get install -y whatweb

#trueseeing
sudo pip3 install trueseeing
 
#Increase maximum java heap size for Jadx
export JAVA_OPTS="-Xmx4G"
source ~/.bashrc

#make tools executable
chmod -R +x tools/

#Clean up
rm -r documentation_old/
rm -r tools_old/
rm -r update/

exit
