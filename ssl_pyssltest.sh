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
	#SSL Implementation (pyssltest)
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	echo -e "\n===================\nPyssltest Log:\n===================\n" >> data/$file_/analysis/static/ssl_scan/logs/pyssltest.log
	echo `date` >> data/$file_/analysis/static/ssl_scan/logs/pyssltest.log
	echo -e "   ${no_color}[-] ${brown}Scanning ${blue}$domain ${brown}${no_color}" >> data/$file_/analysis/static/ssl_scan/logs/pyssltest.log 
	cd tools/pyssltest/ 
	python pyssltest.py -i ../../data/$file_/analysis/static/ssl_scan/domain.txt -o ../../data/$file_/analysis/static/ssl_scan/data.csv -n > ../../data/$file_/analysis/static/ssl_scan/logs/debug.txt
	cat ../../data/$file_/analysis/static/ssl_scan/logs/debug.txt  | sed '/^$/d' | awk '!a[$0]++' >> ../../data/$file_/analysis/static/ssl_scan/logs/pyssltest_scan.log
	rm ../../data/$file_/analysis/static/ssl_scan/logs/debug.txt
	mv results/*.txt ../../data/$file_/analysis/static/ssl_scan/ 

	#This is a script to clean up the ssl scan data 
	echo -e "   ${no_color}[-] ${brown}Cleaning up pyssltest scan data${no_color}" >> ../../data/$file_/analysis/static/ssl_scan/logs/pyssltest.log
	echo -e "\n===================\nSSL Scan Summary:\n===================\n" >> ../../data/$file_/analysis/static/ssl_scan/ssl_summary.txt
	count=1

	while [ $count -le 55 ]
	do
		cat ../../data/$file_/analysis/static/ssl_scan/data.csv | cut -d ',' -f $count >> ../../data/$file_/analysis/static/ssl_scan/ssl_summary.txt
		echo " " >> ../../data/$file_/analysis/static/ssl_scan/ssl_summary.txt
		count=`expr $count + 1`
	done
	cd ../../
	echo -e "   ${no_color}[-] ${brown}Domain scanning completed ${no_color}" >> data/$file_/analysis/static/ssl_scan/logs/pyssltest.log 
	echo -e "   ${no_color}[-] ${brown}SSL data is ready for review!!${no_color}" >> data/$file_/analysis/static/ssl_scan/logs/pyssltest.log
	echo " " >> data/$file_/analysis/static/ssl_scan/logs/pyssltest.log
	echo "=====================================================================" >> data/$file_/analysis/static/ssl_scan/logs/pyssltest.log
	echo " "

