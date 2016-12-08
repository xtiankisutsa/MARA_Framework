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
	#SSL Implementation 
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo -e "=================="
	echo -e "${yellow} MARA SSL scanner ${no_color}"
	echo -e "=================="	
	echo -e "   ${no_color}[-] ${brown}Enter domain to scan:${no_color}" 
	echo -e "   ${light_red}[NOTE] ${brown}Domain scanning takes about 3 minutes! ${no_color}"
	read domain_	
	dump=`echo $domain_ | rev | cut -d '/' -f 1 | rev` 
	mkdir -p data/domain_scans/$dump/logs
	echo $domain_ > data/domain_scans/$dump/domain.txt 
	echo -e "   ${no_color}[-] ${brown}Stage 1 - Scanning ${blue}$domain_ ${brown}...please be patient!!${no_color}"

	#pyssltest
	cd tools/pyssltest/ 
	python pyssltest.py -i ../../data/domain_scans/$dump/domain.txt -o ../../data/domain_scans/$dump/data.csv -n > ../../data/domain_scans/$dump/logs/debug.txt
	cat ../../data/domain_scans/$dump/logs/debug.txt  | sed '/^$/d' | awk '!a[$0]++' >> ../../data/domain_scans/$dump/scan.log
	rm ../../data/domain_scans/$dump/logs/debug.txt
	mv results/*.txt ../../data/domain_scans/$dump/
	
	#This is a script to clean up the ssl scan data 
	echo -e "   ${no_color}[-] ${brown}Cleaning up scan data${no_color}"
	echo -e "\n===================\nSSL Scan Summary:\n===================\n" >> ../../data/domain_scans/$dump/ssl_summary.txt
	count=1

	while [ $count -le 55 ]
	do
		cat ../../data/domain_scans/$dump/data.csv | cut -d ',' -f $count >> ../../data/domain_scans/$dump/ssl_summary.txt
		echo " " >> ../../data/domain_scans/$dump/ssl_summary.txt
		count=`expr $count + 1`
	done
	echo -e "   ${no_color}[-] ${brown}Stage 1 - Domain scanning completed ${no_color}" 
	cd ../
	echo ""

	#testssl 
	echo -e "\n===================\nTestssl Log:\n===================\n"
	echo `date` >> ../data/domain_scans/$dump/logs/testssl.log 
	echo -e "   ${no_color}[-] ${brown}Stage 2 - Scanning ${blue}$domain_ ${brown}${no_color}"
	cd testssl.sh/ 
	./testssl.sh -U -R -I -E -H -S -P -e -p -f -4  --sneaky --logfile ../../data/domain_scans/$dump/ssl_detailed.txt $domain_ | aha > ../../data/domain_scans/$dump/ssl_detailed.html
	echo -e "   ${no_color}[-] ${brown}Stage 2 - Domain scanning completed ${no_color}" 
	cd ../../
	echo -e "   ${no_color}[-] ${brown}SSL data is ready for review!!${no_color}"
	echo -e "   ${light_red}[NOTE] ${brown}The SSL data has been dumped in ${blue}data/domain_scans/$dump ${no_color}"	
	echo " "

exit

