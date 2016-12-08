#!/bin/bash

_file=com.selfcare.safaricom-18.apk

echo -e "\n======\nStart:\n======\n"  >> data/$_file/smali/apktool_files_time.txt
now=$(date +"%T")
echo "$now" >> data/$_file/smali/apktool_files_time.txt

#Create smali files duplicate 
mkdir data/$_file/smali/apktool_cfg
mkdir data/$_file/smali/baksmali_cfg

#Copy the core apk files
#Copying the com folder only will lead to missing out apk files that start with de, org, eu etc.
#This needs to be thought out. 
cp -r data/$_file/smali/apktool/com data/$_file/smali/apktool_cfg
cp -r data/$_file/smali/baksmali/com data/$_file/smali/baksmali_cfg

#List all files 
find data/$_file/smali/apktool_cfg -type f >> data/$_file/smali/apktool_files.txt
find data/$_file/smali/baksmali_cfg -type f >> data/$_file/smali/baksmali_files.txt

#Create cfg per file
for smali_file in `cat data/$_file/smali/apktool_files.txt`;
	do
	python tools/Smali-CFGs/Flow.py -c $smali_file
    cp _flow.png $smali_file.png
    rm $smali_file
    done

#clean up
rm data/$_file/smali/apktool_files.txt
rm _flow.png   

echo -e "\n======\nStop:\n======\n"  >> data/$_file/smali/apktool_files_time.txt
now=$(date +"%T")
echo "$now" >> data/$_file/smali/apktool_files_time.txt

exit

