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

function mara(){
	echo " "
	echo -e "==========================================================================="
	echo -e "${light_green}${bold}$(figlet -f doom MARA Framework)"
	echo -e "${light_green}${bold}[M]${yellow}obile ${light_green}${bold}[A]${yellow}pplication ${light_green}${bold}[R]${yellow}everse Engineering & ${light_green}${bold}[A]${yellow}nalysis Framework"
	echo ""
	echo -e "${light_green}${bold}version: ${yellow}0.2 beta"
	echo -e "${light_green}${bold}Developed by: ${yellow}Christian Kisutsa ${green}${bold}and ${yellow}Chrispus Kamau"
	echo -e "${light_green}${bold}URL: ${yellow}https://github.com/xtiankisutsa/MARA_Framework${no_color}"
	echo ""
	echo -e "=========================================================================="
	echo " "
}

function minions(){
	echo -e "${no_color}[+] ${brown}Assembling minions..."
	mkdir -p data/$file_/analysis/static/general_analysis
	mkdir -p data/$file_/analysis/static/vulnerabilities
	mkdir -p data/$file_/analysis/static/malicious_activity
	mkdir -p data/$file_/analysis/static/ssl_scan/logs
	mkdir -p data/$file_/source/dex
	mkdir -p data/domain_scans/
}

function reversing(){
	echo "========================="
	echo -e "${yellow} Reverse Engineering APK ${no_color}"
	echo "========================="
	#baksmali - Convert APK/Dex to smali code (for better smali code)
	echo -e "${no_color}[+] ${brown}Disassembling Dalvik bytecode to smali bytecode"
	java -jar tools/baksmali-2.1.1.jar data/$file_/unzipped/classes.dex -o data/$file_/smali/baksmali >> /dev/null 2>/dev/null

	#enjarify - convert APK/Dex to jar (dex2jar replacement)
	echo -e "${no_color}[+] ${brown}Disassembling Dalvik bytecode to java bytecode"
	cd tools/enjarify/ 
	./enjarify.sh ../../data/$file_/$file_ -o ../../data/$file_/$file_.jar >> /dev/null 2>/dev/null
	cd ../../
}

function decompile(){
	#jadx - decompile .dex, .apk, .jar or .class to java source code
	echo -e "${no_color}[+] ${brown}Decompiling ${blue}$file_ ${brown}to java source code"
	cd tools/jadx-0.6.0/bin
	./jadx ../../../data/$file_/$file_ -d ../../../data/$file_/source/java >> /dev/null 
	./jadx -f ../../../data/$file_/$file_ -d ../../../data/$file_/source/jadx >> /dev/null 
	cd ../../../
	echo -e "${blue}[INFO] - ${light_green}Done ${no_color}"
	echo " "
}

function preliminary_stage_1(){
	echo "================================="
	echo -e "${yellow} Performing Preliminary Analysis ${no_color}"
	echo "================================="
        #Parsing smali files for analysis by smalisca
	echo -e "${no_color}[+] ${brown}Parsing smali files for analysis"
        smalisca parser -l data/$file_/smali/baksmali -s java -f sqlite --quiet -o data/$file_/smali/$file_.sqlite -d 10 >> /dev/null

	#Dumping assets,libraries and resources
	echo -e "${no_color}[+] ${brown}Dumping apk assets,libraries and resources"
	cd data/$file_/unzipped/
	if [ -d assets ]; then
		cp -r assets ../../../data/$file_/source
	fi

	if [ -d lib ]; then
		cp -r lib ../../../data/$file_/source 
	fi

	if [ -d res/raw ]; then
		cp -r res/raw ../../../data/$file_/source 
	fi

	if [ -f res/values/strings.xml ];then
		cp res/values/strings.xml ../../../data/$file_/analysis/static
	fi

	cd ../../../

	#Extracting the certificate data
	echo -e "${no_color}[+] ${brown}Extracting certificate data"
	echo -e "   ${no_color}[-] ${brown}Loading..."
	cp -r data/$file_/unzipped/META-INF data/$file_/certificate/
	cd data/$file_/certificate/META-INF
	#Checking if certificate is RSA or DSA then extract data
	echo -e "   ${no_color}[-] ${brown}Extracting and dumping certificate"
	if [ -f *.RSA ]; then
		openssl pkcs7 -inform DER -in *.RSA -noout -print_certs -text >> ../openssl_rsa.txt
	   else
		openssl pkcs7 -inform DER -in *.DSA -noout -print_certs -text >> ../openssl_dsa.txt
	fi
	cd ../../../../

	#aapt - extract app permissions	
	function aapt_dump(){	
		cd tools/aapt
		echo -e "${no_color}[+] ${brown}Extracting permissions"
		./$aapt_ dump permissions ../../data/$file_/$file_ >> ../../data/$file_/analysis/static/general_analysis/permissions.txt

		#strings - getting all strings from APK
		echo -e "${no_color}[+] ${brown}Dumping apk strings"
		./$aapt_ dump strings ../../data/$file_/$file_ >> ../../data/$file_/analysis/static/general_analysis/strings_aapt.txt

		#configurations - getting all configurations from APK
		echo -e "${no_color}[+] ${brown}Dumping configurations"
		./$aapt_ dump configurations ../../data/$file_/$file_ >> ../../data/$file_/analysis/static/general_analysis/configurations.txt
		cd ../../ 		
	}
	
	arch=`dpkg --print-architecture`
	if [  "$arch" == armhf ]  || [ "$arch" == armel ] || [ "$arch" == arm64 ] ;
	then 
	    aapt_=aapt_arm
		aapt_dump
	else
		aapt_=aapt
		aapt_dump	

		#Dump dex from unzipped apk
		echo -e "${no_color}[+] ${brown}Dumping dex bytecode"
		cd tools/dexdump
		./dexdump -l plain ../../data/$file_/unzipped/classes.dex > dex.txt
		./dexdump -l xml ../../data/$file_/unzipped/classes.dex > dex.xml	
		mv dex.xml dex.txt ../../data/$file_/source/dex
		cd ../../
	fi

	#Dump methods and classes
	echo -e "${no_color}[+] ${brown}Dumping methods and classes"
	cd tools/
	java -jar ClassyShark.jar -inspect ../data/$file_/$file_ >> ../data/$file_/analysis/static/general_analysis/inspect.txt
	java -jar ClassyShark.jar -export ../data/$file_/$file_ > /dev/null 2>/dev/null
	mv *.txt ../data/$file_/analysis/static/general_analysis/
	rm AndroidManifest.xml_dump
	cd ..

	#bugs - hunting for bugs in the APK :D 
	echo -e "${no_color}[+] ${brown}Analyzing apk for potential bugs"
	cd tools/AndroBugs
	cp ../../data/$file_/$file_ .
	python2 androbugs.py -f $file_ >> ../../data/$file_/analysis/static/general_analysis/bugs.txt
	rm $file_
	cd ../../ 

	#Looking for potential malicious behaviours 
	echo -e "${no_color}[+] ${brown}Analyzing apk for potential malicious behaviour"
	cd tools/androwarn
	cp ../../data/$file_/$file_ .
	python androwarn.py -i $file_ -r html -v 3 > /dev/null 2>/dev/null		
	cp -r Report/ ../../data/$file_/analysis/static/malicious_activity/ > /dev/null 2>/dev/null
	rm Report/*.html > /dev/null 2>/dev/null
	rm $file_
	cd ../../
}

function compiler(){
	#Identifying compilers, packers and obfuscators
	echo -e "${no_color}[+] ${brown}Identifying compiler/packer"
	apkid data/$file_/$file_ >> data/$file_/analysis/static/general_analysis/compiler_detection.txt
}

function preliminary_stage_2(){
	#Dump any file system commands and binary execution paths
	echo -e "${no_color}[+] ${brown}Dumping execution paths"
	echo -e "\n==========================\nJadx:\n==========================\n" >> data/$file_/analysis/static/general_analysis/exec_paths.txt 
	grep -rE "/acct/|/cache/|/data/|/dev/|/etc/|/init/|/mnt/|/proc/|/sbin/|/sdcard/|/sys/|/system/|/vendor/" data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/exec_paths.txt
	echo " " >> data/$file_/analysis/static/general_analysis/exec_paths.txt 
	echo -e "\n==========================\nJava:\n==========================\n" >> data/$file_/analysis/static/general_analysis/exec_paths.txt
	grep -rE "/acct/|/cache/|/data/|/dev/|/etc/|/init/|/mnt/|/proc/|/sbin/|/sdcard/|/sys/|/system/|/vendor/" data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/exec_paths.txt 

	#Dump any IP addresses
	echo -e "${no_color}[+] ${brown}Dumping IP addresses"
	echo -e "\n==========================\nJadx:\n==========================\n" >> data/$file_/analysis/static/general_analysis/ip.txt
	grep -rE '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' data/$file_/source/jadx >> data/$file_/analysis/static/general_analysis/ip.txt
	echo " " >> data/$file_/analysis/static/general_analysis/ip.txt
	echo -e "\n==========================\nJava:\n==========================\n" >> data/$file_/analysis/static/general_analysis/ip.txt
	grep -rE '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' data/$file_/source/java >> data/$file_/analysis/static/general_analysis/ip.txt
	echo " " >> data/$file_/analysis/static/general_analysis/ip.txt

	#Dump any URLs
	echo -e "${no_color}[+] ${brown}Dumping URL"
	echo -e "\n==========================\nJadx:\n==========================\n" >> data/$file_/analysis/static/general_analysis/url.txt
	grep -rE '(http|https|ftp|ftps)://[^/\n ]*' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/url.txt
	echo " " >> data/$file_/analysis/static/general_analysis/url.txt
	echo -e "\n==========================\nJava:\n==========================\n" >> data/$file_/analysis/static/general_analysis/url.txt
	grep -rE '(http|https|ftp|ftps)://[^/\n ]*' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/url.txt
	echo " " >> data/$file_/analysis/static/general_analysis/url.txt

	#Cleaned up IP addresses and URL 
	echo -e "\n==========================\nIPs:\n==========================\n" >> data/$file_/analysis/static/general_analysis/ip_url.txt
	grep -rEo '(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)' data/$file_/source/jadx | cut -d ':' -f 2 | sort -u >> data/$file_/analysis/static/general_analysis/ip_url.txt
	echo -e "\n==========================\nDomains:\n==========================\n" >> data/$file_/analysis/static/general_analysis/ip_url.txt
	grep -Ero '(http|https|ftp|ftps)://[a-zA-Z0-9./?=_-]*' data/$file_/source/jadx | grep -Ev '(schemas.android.com|play.google.com)' | cut -d ':' -f 2-3 | sort -u | sort -u >> data/$file_/analysis/static/general_analysis/ip_url.txt

	#Dump any URIs
	echo -e "${no_color}[+] ${brown}Dumping URI"
	echo -e "\n==========================\nJadx:\n==========================\n" >> data/$file_/analysis/static/general_analysis/uri.txt
	grep -rE '(file|javascript|data)://[a-zA-Z0-9./?=_-]*' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/uri.txt
	echo " " >> data/$file_/analysis/static/general_analysis/uri.txt
	echo -e "\n==========================\nJava:\n==========================\n" >> data/$file_/analysis/static/general_analysis/uri.txt
	grep -rE '(file|javascript|data)://[a-zA-Z0-9./?=_-]*' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/uri.txt
	echo " " >> data/$file_/analysis/static/general_analysis/uri.txt

	#Dump any email in the fileunary
	echo -e "${no_color}[+] ${brown}Dumping emails"
	echo -e "\n==========================\nJadx:\n==========================\n" >> data/$file_/analysis/static/general_analysis/emails.txt 
	#grep -rE "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/emails.txt 
	grep -rE "[\w.-]+@[\w-]+\.[\w.]+" data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/emails.txt
	echo " " >> data/$file_/analysis/static/general_analysis/emails.txt 
	echo -e "\n==========================\nJava:\n==========================\n" >> data/$file_/analysis/static/general_analysis/emails.txt 
	#grep -rE "\b[a-zA-Z0-9.-]+@[a-zA-Z0-9.-]+\.[a-zA-Z0-9.-]+\b" data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/emails.txt 
	grep -rE "[\w.-]+@[\w-]+\.[\w.]+" data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/emails.txt

	#Dump all strings
	echo -e "${no_color}[+] ${brown}Dumping additonal strings"
	strings data/$file_/$file_ >> data/$file_/analysis/static/general_analysis/strings.txt
	echo -e "${blue}[INFO] ${light_green}Done ${no_color}"
	echo " "
}


function manifest(){
	#This is where the fun starts :) 
	echo "=============================="
	echo -e "${yellow} Performing Manifest Analysis ${no_color}"
	echo "=============================="
	#apktool - Convert Android Manifest and dump smali
	echo -e "${no_color}[+] ${brown}Decoding Manifest file and dumping smali bytecode" 
	java -jar tools/apktool_2.1.0.jar d -q data/$file_/$file_ -o data/$file_/buffer >> /dev/null 
	mv data/$file_/buffer/AndroidManifest.xml data/$file_
	mv data/$file_/buffer/smali data/$file_/smali/apktool
	mv data/$file_/buffer/res/values* data/$file_/unzipped/res/ 
	rm -r data/$file_/buffer

	echo "===========================" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " Android Manifest Analysis " >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo "===========================" >> data/$file_/analysis/static/general_analysis/attack_surface.txt

	echo -e "\n==========================\nPackage Name:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	cat data/$file_/AndroidManifest.xml |  grep "package=" | sed -e 's/.*package="//;s/".*//' >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt

	#Lets dump intents
	echo -e "${no_color}[+] ${brown}Extracting activities"
	echo -e "\n==========================\nIntents:\n==========================\n">> data/$file_/analysis/static/general_analysis/attack_surface.txt
	sed -n '/activity/,/activity/p'  data/$file_/AndroidManifest.xml | grep -B 100 "</activity>" | grep -E "action|category" | cut -d '"' -f 2 >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt

	#Lets dump exported activties
	echo -e "${no_color}[+] ${brown}Extracting exported activties" 
	echo -e "\n==========================\nExported activities:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	sed -n '/activity/,/activity/p'  data/$file_/AndroidManifest.xml | grep -B 100 "<activity" | grep -E 'exported="true"' | sed -e 's/.*name="//;s/".*//' >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt

	#Lets dump receivers
	echo -e "${no_color}[+] ${brown}Extract receivers"
	echo -e "\n==========================\nReceivers:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	sed -n '/receiver/,/receiver/p'  data/$file_/AndroidManifest.xml | grep -B 100 "</receiver>"  | grep -E 'action|category' | cut -d '"' -f 2 >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt

	#Lets dump exported receivers
	echo -e "${no_color}[+] ${brown}Extracting exported receivers" 
	echo -e "\n==========================\nExported receivers:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	sed -n '/receiver/,/receiver/p'  data/$file_/AndroidManifest.xml | grep -B 100 "</receiver>"  | grep 'exported="true"' | sed -e 's/.*name="//;s/".*//' >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	
	#Lets dump services
	echo -e "${no_color}[+] ${brown}Extracting services"
	echo -e "\n==========================\nServices:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	sed -n '/service/,/service/p'  data/$file_/AndroidManifest.xml | grep -B 100 "</service>" | grep "name=" | grep 'service' | sed -e 's/.*name="//;s/".*//' >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt

	#Lets dump exported services
	echo -e "${no_color}[+] ${brown}Extracting exported services"
	echo -e "\n==========================\nExported services:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	sed -n '/service/,/service/p'  data/$file_/AndroidManifest.xml | grep -B 100 "</service>" | grep 'service' | grep 'exported="true"' | sed -e 's/.*name="//;s/".*//'  >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	
	#Lets check if the app is debuggable
	echo -e "${no_color}[+] ${brown}Checking if apk is debuggable"
	echo -e "\n==========================\nDebuggable:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	grep -E 'android:debuggable="true"' data/$file_/AndroidManifest.xml >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	
	#Lets check if the app allows backups
	echo -e "${no_color}[+] ${brown}Checking if apk can be backed up"
	echo -e "\n==========================\nBackup:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	grep -E 'android:allowBackup="true"' data/$file_/AndroidManifest.xml >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	
	#Lets check if the apk can run secret code to the dialer
	echo -e "${no_color}[+] ${brown}Checking if apk can run secret codes into the dialer"
	echo -e "\n==========================\nSecret Codes:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	grep -E 'android_secret_code' data/$file_/AndroidManifest.xml >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	
	#Lets check if binary SMS recevier is configured to listen on a port. 
	echo -e "${no_color}[+] ${brown}Checking if apk can receive binary SMS"
	echo -e "\n==========================\nBinary SMS:\n==========================\n" >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	grep -E 'android:port' data/$file_/AndroidManifest.xml >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo " " >> data/$file_/analysis/static/general_analysis/attack_surface.txt
	echo -e "${blue}[INFO] ${light_green}Done${no_color}"
	echo " "
}

function android_analysis(){
	#Start android analysis 
	./owasp_static_android.sh
}

#This feature is coming soon 
#function iOS_analysis(){
	#Start analysis
#	./owasp_static_iOS.sh
#}

function final(){
	echo "====================="
	echo -e "${yellow} Finalizing Analysis ${no_color}"
	echo "====================="
	#Listing all files and properties
	echo -e "${no_color}[+] ${brown}Listing all files"
	tree data/$file_/analysis > data/$file_/analysis/static/general_analysis/file_list.txt

	#zipping apk for extraction
	cd data/
	echo -e "${no_color}[+] ${brown}Zipping analysis data for extraction"
	zip -r $file_.zip $file_ >> /dev/null
	echo -e "${no_color}[+] ${brown}Dispersing minions..."
	cd ..
	echo -e "${blue}[INFO] ${light_green}Done${no_color}"
	echo " "
	echo -e "${no_color}[+] ${brown}That was easy wasnt it? :D"
	echo -e "${light_red}[NOTE] ${brown}The analysis data has been dumped in ${blue}data/$file_ ${no_color}"
	echo " "
	echo "====================================================================="
	echo " "
} 

#+++++++++++++++++++++++
#Mara Framework Options
#+++++++++++++++++++++++
#Check if APK file has been provided
if ! [ "$1" ] || [ "$1" == '-h' ]  || [ "$1" == '--help' ] || ! [ "$2" ]; then 
mara
echo -e "${light_green}${bold}Usage:"
echo -e "${yellow}$0 [options] <path> (.dex, .apk, .jar or .class)"
echo ""
echo -e "${light_green}${bold}Options:"
echo -e "${yellow}-s, --single       - analyze single apk
-m, --multiple     - analyze multiple apks
-d, --dex          - analyze dex file
-j, --jar          - analyze jar file
-c, --class        - analyze class file
-h, --help         - print this help"
echo ""
echo -e "${light_green}${bold}Example:"
echo -e "${yellow}single APK analysis e.g $0 -s </path/to/apk/>
multiple APK analysis e.g $0 -m </path/to/apk/folder/>
dex file analysis e.g $0 -d </path/to/dex/file/>
jar file analysis e.g $0 -j </path/to/jar/file/>
class file analysis e.g $0 -c </path/to/class/file/>${no_color}"
exit -1
fi

#++++++++++++++
#Apk analysis
#++++++++++++++
if [ $1 == '-s' ] || [ $1 == '--single' ] ; then
	mara
	sleep 2
	echo "=============="
	echo -e "${yellow} APK analysis ${no_color}"
	echo "=============="
	echo -e "${no_color}[+] ${brown}Initializing..."
	file_=`echo $2 | rev | cut -d '/' -f 1 | rev`
	echo -e "${no_color}[+] ${brown}Setting up playground..."
	export file_
	mkdir -p data/$file_/unzipped
	mkdir -p data/$file_/certificate

	minions
	echo -e "${no_color}[+] ${brown}Preparing ${blue}$file_"
	cp $2 data/$file_/
	unzip $2 -d data/$file_/unzipped >> /dev/null
	echo -e "${blue}[INFO] - ${light_green}Done ${no_color}"
	echo " "

	#Call the necessary functions
	reversing
	decompile
	preliminary_stage_1
	compiler
	preliminary_stage_2
	manifest
	android_analysis
	final
fi

#++++++++++++++++++++++
#Multiple Apk analysis
#++++++++++++++++++++++
if [ $1 == '-m' ] || [ $1 == '--multiple' ] ; then
	mara
	sleep 2
	echo -e "${light_red}[NOTE] ${brown}- This analysis may take a while!!!${no_color}"
	echo -e "${light_red}[NOTE] ${brown}- Better grab a cup of coffee or 10!!!${no_color}"
	echo ""
	apks=$2
	for source_apk in $apks/*;
	do
	file_=`echo $source_apk | rev | cut -d '/' -f 1 | rev`
	echo "========================="
	echo -e "${yellow}Analyzing $file_ ${no_color}"
	echo "========================="
	echo -e "${no_color}[+] ${brown}Initializing..."
	echo -e "${no_color}[+] ${brown}Setting up playground..."
	export file_
	mkdir -p data/$file_/unzipped
	mkdir -p data/$file_/certificate
	minions
	sleep 1
	echo -e "${no_color}[+] ${brown}Preparing ${blue}$file_"
	cp $source_apk data/$file_/
	unzip $source_apk -d data/$file_/unzipped >> /dev/null
	echo -e "${blue}[INFO] - ${light_green}Done ${no_color}"
	echo " "
	sleep 1
	#Call the necessary functions
	reversing
	decompile
	preliminary_stage_1
	compiler
	preliminary_stage_2
	manifest
	android_analysis
	final
	done
fi

#++++++++++++++
#Dex analysis
#++++++++++++++
if [ $1 == '-d' ] || [ $1 == '--dex' ] ; then
	mara
	sleep 2
	echo "===================="
	echo -e "${yellow} Preparing Dex file ${no_color}"
	echo "===================="
	echo -e "${no_color}[+] ${brown}Initializing..."
	file_=`echo $2 | rev | cut -d '/' -f 1 | rev`
	echo -e "${no_color}[+] ${brown}Setting up playground..."
	export file_
	mkdir -p data/$file_/unzipped
	minions
	echo -e "${no_color}[+] ${brown}Preparing ${blue}$file_${no_color}"
	cp $2 data/$file_/
	cp $2 data/$file_/unzipped
	mv data/$file_/unzipped/$file_ data/$file_/unzipped/classes.dex 2>/dev/null
	echo -e "${blue}[INFO] - ${light_green}Done ${no_color}"
	echo " "
	reversing
	rm -r data/$file_/unzipped

	#Call the necessary functions
	decompile
	echo "====================="
	echo -e "${yellow} Performing Analysis ${no_color}"
	echo "=====================" 
	compiler
	preliminary_stage_2
	android_analysis
	final
fi

#++++++++++++++
#Jar analysis
#++++++++++++++
if  [ $1 == '-j' ] || [ $1 == '--jar' ] ; then
	mara
	sleep 2
	echo "===================="
	echo -e "${yellow} Preparing Jar file ${no_color}"
	echo "===================="
	echo -e "${no_color}[+] ${brown}Initializing..."
	file_=`echo $2 | rev | cut -d '/' -f 1 | rev`

	#Call the necessary functions
	echo -e "${no_color}[+] ${brown}Setting up playground..."
	export file_
	minions
	echo -e "${no_color}[+] ${brown}Preparing ${blue}$file_"
	cp $2 data/$file_/
	echo -e "${blue}[INFO] - ${light_green}Done ${no_color}"
	echo " "

	#Call the necessary functions
	echo "====================="
	echo -e "${yellow} Performing Analysis ${no_color}"
	echo "====================="  
	decompile
	preliminary_stage_2
	android_analysis
	final	
	exit 1
fi
	
#+++++++++++++++
#Class analysis
#+++++++++++++++
if [ $1 == '-c' ] || [ $1 == '--class' ] ; then
	mara
	sleep 2
	echo "======================"
	echo -e "${yellow} Preparing Class file ${no_color}"
	echo "======================"
	echo -e "${no_color}[+] ${brown}Initializing..."
	file_=`echo $2 | rev | cut -d '/' -f 1 | rev`

	#Call the necessary functions
	echo -e "${no_color}[+] ${brown}Setting up playground..."
	export file_
	minions
	echo -e "${no_color}[+] ${brown}Preparing ${blue}$file_"
	cp $2 data/$file_/
	echo -e "${blue}[INFO] - ${light_green}Done ${no_color}"
	echo " "

	#Call the necessary functions
	echo "====================="
	echo -e "${yellow} Performing Analysis ${no_color}"
	echo "=====================" 
	decompile
	preliminary_stage_2
	android_analysis
	final
fi
	
