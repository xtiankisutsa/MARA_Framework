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

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#SSL Implementation (testssl)
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo -e "\n===================\nTestssl Log:\n===================\n" >> data/$file_/analysis/dynamic/ssl_scan/logs/testssl.log
	echo `date` >> data/$file_/analysis/dynamic/ssl_scan/logs/testssl.log
	echo -e "   ${no_color}[-] ${brown}Scanning ${blue}$domain ${brown}${no_color}" >> data/$file_/analysis/dynamic/ssl_scan/logs/testssl.log 
	cd tools/testssl.sh/ 
	./testssl.sh -U -R -I -E -H -S -P -e -p -f -4  --sneaky --logfile ../../data/$file_/analysis/dynamic/ssl_scan/ssl_detailed.txt $domain | aha > ../../data/$file_/analysis/dynamic/ssl_scan/ssl_detailed.html
	echo -e "   ${no_color}[-] ${brown}Domain scanning completed ${no_color}" >> ../../data/$file_/analysis/dynamic/ssl_scan/logs/testssl.log 
	echo -e "   ${no_color}[-] ${brown}SSL data is ready for review!!${no_color}" >> ../../data/$file_/analysis/dynamic/ssl_scan/logs/testssl.log 
	cd ../../
	echo " " data/$file_/analysis/dynamic/ssl_scan/logs/testssl.log 
	echo "=====================================================================" >> data/$file_/analysis/dynamic/ssl_scan/logs/testssl.log
	echo " "
	
exit



