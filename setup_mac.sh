#!/bin/bash

#These are the requirements for running this tool:

#Update bash path in scripts
sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' apktool_cfg.sh >> apktool_cfg.sh.tmp
rm apktool_cfg.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' deobfuscator.sh >> deobfuscator.sh.tmp
rm deobfuscator.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' setup.sh >> setup.sh.tmp
rm setup.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' update.sh >> update.sh.tmp
rm update.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' baksmali_cfg.sh >> baksmali_cfg.sh.tmp
rm baksmali_cfg.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' mara.sh >> mara.sh.tmp
rm mara.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' ssl_pyssltest.sh >> ssl_pyssltest.sh.tmp
rm ssl_pyssltest.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' cfg.sh >> cfg.sh.tmp
rm cfg.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' owasp_static_android.sh >> owasp_static_android.sh.tmp
rm owasp_static_android.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' ssl_scanner.sh >> ssl_scanner.sh.tmp
rm ssl_scanner.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' de-guard.sh  >> de-guard.sh.tmp
rm de-guard.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' setup_mac.sh >> setup_mac.sh.tmp
rm setup_mac.sh.tmp

sed -i.tmp 's|'/bin/bash'|/usr/local/bin/bash|g' ssl_testssl.sh >> ssl_testssl.sh.tmp
rm ssl_testssl.sh.tmp

chmod +x *.sh

#Package update
brew update -y -v
sudo -H pip install --upgrade pip
sudo pip3 install --upgrade pip

#Install bash
brew install bash -y -v

#Java JDK
brew tap caskroom/cask -y -v
brew tap caskroom/versions -y -v
brew cask install java -y

#Sed
#Will replace your BSD sed with GNU sed
brew install gnu-sed --with-default-names -y

#Git
brew install git -y -v

#Tree
brew install tree -y -v

#Figlet
brew install figlet -y -v

#unrest
sudo -H pip install unirest

#aha - Ansi HTML Adapter
#sudo apt-get -y install aha
brew install aha -y -v

#Python3
brew install python3 -y -v

#Androwarn dependencies
sudo -H pip install Jinja2

#Smali graph generation dependency
sudo -H pip install pydot

#configparser
sudo -H pip install configparser

#Smalisca
sudo -H pip install smalisca

#APKiD
cd tools/
git clone --recursive https://github.com/rednaga/yara-python-1 yara-python
cd yara-python/
sudo -H python setup.py build --enable-dex install
sudo -H pip install apkid
cd ../../

#whatweb
sudo apt-get install -y whatweb

#trueseeing
sudo pip3 install trueseeing

#Increase maximum java heap size for Jadx
export JAVA_OPTS="-Xmx4G"
source ~/.bashrc

#make tools executable
chmod -R +x tools/

exit
