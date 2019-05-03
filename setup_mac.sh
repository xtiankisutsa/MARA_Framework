#!/usr/bin/env bash

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
brew update -v

declare -a brew_packages
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

#Install pip
curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
# sudo -H python get-pip.py
sudo -H python3 get-pip.py
rm get-pip.py

#Upgrade pip
sudo -H pip install --upgrade pip
sudo -H pip3 install --upgrade pip

#unrest
sudo -H pip2 install unirest

#Androwarn dependencies
sudo -H pip3 install Jinja2

#Smali graph generation dependency
sudo -H pip3 install pydot

#configparser
sudo -H pip3 install configparser

#Smalisca
sudo -H pip3 install smalisca

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

#trueseeing
sudo pip3 install trueseeing

#Increase maximum java heap size for Jadx
echo "export JAVA_OPTS='-Xmx4G'" >> ~/.bashrc
source ~/.bashrc

#make tools executable
chmod -R +x tools/

#Clean up
rm -r documentation_old/
rm -r tools_old/
rm -r update/

exit
