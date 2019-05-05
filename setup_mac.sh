#!/usr/bin/env bash
# MARA_Framework/setup_mac.sh

# setup_mac.sh
#   Install MARA dependencies
# Tested on:
#	macOS Mojave (10.14.4)


function brew_deps {
	# Update brew and all formulas
	brew update -v

	brew_packages=(python python2 bash gnu-sed git tree figlet aha)
	# Sed will replace your BSD sed with GNU sed
	# aha - Ansi HTML Adapter

	for package in "${brew_packages[@]}"; do
		brew install "${package}"
	done
}


function install_java {
	# Java JDK
	brew cask install java
}


function pip_deps {

	pip3_packages=(Jinja2 pydot configparser smalisca trueseeing)
	# Jinja2 - Androwarn dependencies
	# pydot - Smali graph generation dependency

	# Upgrade pip
	sudo -H pip install --upgrade pip
	sudo -H pip3 install --upgrade pip

	for package in "${pip3_packages[@]}"; do
		sudo -H pip3 install "${package}"
	done

	# unrest
	sudo -H pip2 install unirest
}


function install_apkid {
	(
		# Do this in a sub shell 
		# so we don't need to cd back into the top level MARA dir
		cd tools/ || exit
		git clone --recursive https://github.com/rednaga/yara-python-1 yara-python
		cd yara-python/ || exit
		sudo -H python setup.py build --enable-dex install
		sudo -H pip2 install apkid
	)
}


function clean_up {
	# Clean up
	cleanup_dirs=(documentation_old tools_old update)

	for dir in "${cleanup_dirs[@]}"; do
		if [[ -d "${dir}" ]]; then
			rm -rf "{dir:?}"
		fi
	done
}


function main {
	
	declare -a brew_packages
	declare -a pip3_packages
	declare -a cleanup_dirs

	chmod +x *.sh

	brew_deps
	install_java
	pip_deps
	install_apkid

	# TODO: Install whatweb
	# https://github.com/urbanadventurer/WhatWeb

	# Increase maximum java heap size for Jadx
	echo "export JAVA_OPTS='-Xmx4G'" >> ~/.bashrc
	source ~/.bashrc

	# Make tools executable
	sudo chown -R "${USER}" tools/
	chmod -R +x tools/

	clean_up

	exit 0
}

main "$@"

