#!/bin/bash

################################################
#Deguard Deobfuscation module by Munir Njiru"  #
################################################

echo "==================="  >> data/$file_/source/deobfuscated/deobf.log
echo " MARA Deobfuscator "  >> data/$file_/source/deobfuscated/deobf.log
echo "==================="  >> data/$file_/source/deobfuscated/deobf.log

	echo "[+] Preparing environment" >> data/$file_/source/deobfuscated/deobf.log
	echo -e "   [-] Setting up directories..." >> data/$file_/source/deobfuscated/deobf.log
	cp data/$file_/$file_ data/$file_/source/deobfuscated
	cd data/$file_/source/deobfuscated

	sessionFile="session.key"
	fileName=$file_ 
	actualsize=$(du -k "$fileName" | cut -f1)

	begin=$(date +"%s")	
	echo "   [-] APK File size is:" ${actualsize} "KB"  >> deobf.log
	echo "[INFO] - Done" deobf.log
	echo  " " >> deobf.log

	echo "[+] Uploading APK For Analysis"  >> deobf.log
	curl --progress-bar --form "file=@${fileName}" "http://www.apk-deguard.com/upload" | cut -d '"' -f 8 > ${sessionFile}
    	echo "    [-] Upload complete..."  >> deobf.log
	echo "    [-] Session key saved in: "$sessionFile  >> deobf.log
	echo "    [-] Reading session key"  >> deobf.log
	read -d $'\x04' line < "$sessionFile" 
	echo "[INFO] - Done" deobf.log
   	echo " "  >> deobf.log

    	echo "[+] Deobfuscating $file_ ...please wait!!"  >> deobf.log
   	sleep 30

	FetchRoot="http://www.apk-deguard.com/fetch?fp="

	#Fetching mapping file
	fetchMapping="&q=mapping" 
	echo "    [-] Downloading mapping file" >> deobf.log
	mapping=`curl --progress-bar "${FetchRoot}${line}${fetchMapping}"` 
	count=0

	while [ -z "$mapping" ] && [ $count -le 15 ]; do
		echo "      [-] Retrying in 30 seconds" >> deobf.log
		sleep 30
		((count++))
	done
	
	if [ $count -eq 16 ]; then
		echo "    [NOTE] Deobfuscation is taking too long, check the validity of your apk!!" >> deobf.log
		exit
	else
	
		echo $mapping > mapping-${fileName}.txt
		echo "    [INFO] - Done" >> deobf.log
		echo " " >> deobf.log

		#Fetching source file
		fetchSource="&q=src" 
		echo "    [-] Downloading source file"	>> deobf.log
		curl --progress-bar "${FetchRoot}${line}${fetchSource}" --output source-${fileName}.zip 
		
		zipsize=$(du "source-${fileName}.zip" | cut -f1)

		while [ ${zipsize} -eq 0 ]; do
			echo "      [-] Retrying in 30 seconds" >> deobf.log
			sleep 30
			curl --progress-bar "${FetchRoot}${line}${fetchSource}" --output source-${fileName}.zip
			zipsize=$(du "source-${fileName}.zip" | cut -f1)
		done
		
		unzip -q -d source-${fileName} source-${fileName}.zip 
	  	rm -r source-${fileName}.zip
		echo "    [INFO] - Done" >> deobf.log
		echo " " >> deobf.log

		#Fetching deobfuscated apk file
		fetchApk="&q=apk" 
		echo "    [-] Downloading deobfuscated APK file" >> deobf.log
		ApkFile=$(curl --progress-bar "${FetchRoot}${line}${fetchApk}" --output "deobfuscated-${fileName}")    
		echo $ApkFile  
		echo "    [INFO] - Done" >> deobf.log
		echo " " >> deobf.log

		echo "[INFO] - Deobfuscation complete..." >> deobf.log	
	 	rm $file_
		termin=$(date +"%s")
		difftimelps=$(($termin-$begin))
		echo "    [-] $(($difftimelps / 60)) minutes and $(($difftimelps % 60)) seconds elapsed for deobfuscation." >> deobf.log;  
		exit

	    	cd ../../../../

        fi

exit
