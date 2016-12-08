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

################################################
#Deguard Deobfuscation module by Munir Njiru"  #
################################################

#Check if APK file has been provided
if ! [ "$1" ] || [ "$1" == '-h' ]  || [ "$1" == '--help' ] || ! [ "$1" ] || ! [ "$2" ]; then 
echo -e "==================="
echo -e "${yellow} MARA Deobfuscator ${no_color}"
echo -e "==================="
echo -e "${light_green}${bold}Usage:${no_color}"
echo -e "${brown}$0 --apk <path/to/apk>${no_color}"
echo ""

else

#++++++++++++++
#Apk analysis
#++++++++++++++

echo -e "==================="
echo -e "${yellow} MARA Deobfuscator ${no_color}"
echo -e "==================="

echo -e "${no_color}[+] ${brown}Preparing environment${no_color}"

fileName=`echo $2 | rev | cut -d '/' -f 1 | rev`
mkdir -p data/deobf/$fileName
cp $2 data/deobf/$fileName/
cd data/deobf/$fileName/


sessionFile="session.key"
maxsize=16000    # 16MB
actualsize=$(du -k "$fileName" | cut -f1)

if [ $actualsize -ge $maxsize ]; then
	echo -e "   ${no_color}[-] ${brown}File size is:${no_color}"${actualsize} "KB"
	echo -e "    ${light_red}[NOTE] ${light_red}APK size is over 16 MB , deobfuscation module will now exit sorry :(${no_color}"   
	exit
else
	begin=$(date +"%s")	
	echo -e "   ${no_color}[-] ${brown}APK file size is:${no_color}" ${actualsize} "KB"
	echo -e "${blue}[INFO] - ${light_green}Done ${no_color}"
	echo " "

	echo -e "${no_color}[+] ${brown}Uploading APK For Analysis${no_color}"
	curl --progress-bar --form "file=@${fileName}" "http://www.apk-deguard.com/upload" | cut -d '"' -f 8 > ${sessionFile} 
    	echo -e "   ${no_color}[-] ${brown}Upload complete...${no_color}" 
	echo -e "   ${no_color}[-] ${brown}Session key saved in: ${no_color}"$sessionFile
	echo -e "   ${no_color}[-] ${brown}Reading session key${no_color}" 
	read -d $'\x04' line < "$sessionFile" 
	##echo "Session key is: "$line  
	echo -e "${blue}[INFO] - ${light_green}Done ${no_color}" 
    	echo " "   

   	echo -e "${no_color}[+] ${brown}Deobfuscating ${blue}$file_ ${brown}...please be patient!!${no_color}"   
   	sleep 30  

	FetchRoot="http://www.apk-deguard.com/fetch?fp="

	#Fetching mapping file
	fetchMapping="&q=mapping" 
	echo -e "   ${no_color}[-] ${brown}Downloading mapping file ${no_color}"
	mapping=`curl --progress-bar "${FetchRoot}${line}${fetchMapping}"`
	count=0

	while [ -z "$mapping" ] && [ $count -le 10 ]; do
		echo "      [-] Retrying in 30 seconds"
		sleep 30
		((count++))
		mapping=`curl --progress-bar "${FetchRoot}${line}${fetchMapping}"`
	done

	if [ $count -eq 11 ]; then
		echo -e "    ${light_red}[NOTE] ${light_red}Deobfuscation is taking too long, check the validity of your apk!!"
		exit
	else

	echo $mapping > mapping-${fileName}.txt
	echo " "

	#Fetching source file
	fetchSource="&q=src" 
	echo -e "   ${no_color}[-] ${brown}Downloading source file ${no_color}"	
	curl --progress-bar "${FetchRoot}${line}${fetchSource}" --output source-${fileName}.zip

	zipsize=$(du "source-${fileName}.zip" | cut -f1)

	while [ ${zipsize} -eq 0 ]; do
		echo "      [-] Retrying in 30 seconds"
		sleep 30
		curl --progress-bar "${FetchRoot}${line}${fetchSource}" --output source-${fileName}.zip
		zipsize=$(du "source-${fileName}.zip" | cut -f1)
	done

    	unzip -q -d source-${fileName} source-${fileName}.zip
  	rm -r source-${fileName}.zip

	echo " "
	
	#Fetching deobfusctated apk file
	fetchApk="&q=apk" 
	echo -e "   ${no_color}[-] ${brown}Downloading APK file ${no_color}"
	ApkFile=$(curl --progress-bar "${FetchRoot}${line}${fetchApk}" --output "deobfuscated-${fileName}")    
	echo $ApkFile  

	echo -e "${blue}[INFO] - ${light_green}Deobfuscation complete...${no_color}"	
 
	termin=$(date +"%s")
	difftimelps=$(($termin-$begin))
	echo -e "   ${no_color}[-] ${brown}$(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for deobfuscation.${no_color}";  
	

    cd ../../../

    fi
fi

fi

exit


