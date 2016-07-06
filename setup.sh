#!/bin/bash

#These are the requirements for running this tool:

#Java JDK
sudo apt-get -y install openjdk-7-jdk

#Tree
sudo apt-get -y install tree

#install 32bit libs
sudo dpkg --add-architecture i386
sudo apt-get update
sudo apt-get -y install libgtk2.0-0:i386 libxxf86vm1:i386 libsm6:i386 lib32stdc++6

#Figlet
sudo apt-get -y install figlet
sudo cp tools/figlet/doom.flf /usr/share/figlet

#unrest
sudo pip install unirest

#aha - Ansi HTML Adapter
sudo apt-get -y install aha

#Python3
sudo apt-get -y install python3

#Androwarn dependencies
sudo apt-get -y install python python-jinja2 git

#Smali graph generation dependency
sudo pip install pydot

#Smalisca
sudo pip install smalisca




