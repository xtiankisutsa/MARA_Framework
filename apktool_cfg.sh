#!/bin/bash

cd tools/Smali-CFGs/
mv ../../data/$file_/smali/apktool/android ../../data/$file_/smali/android_apktool

for smali_file in `find ../../data/$file_/smali/apktool -name *.smali`;
do
	echo $smali_file | cut -d "/" -f 3- >> ../../data/$file_/smali/apktool_cfg.log 
	newname=`echo $smali_file | awk -F "/" '{print $NF}'`
	newpath=`echo $smali_file | cut -d "/" -f 7-`
	path=`echo $newpath | rev | cut -d "/" -f 2- | rev`
	python Flow.py -c $smali_file 2>/dev/null
	mkdir -p ../../data/$file_/smali/apktool_cfg/$path
	cp _flow.png ../../data/$file_/smali/apktool_cfg/$path/$newname.png
done

echo "CFG generation done!" >> ../../data/$file_/smali/apktool_cfg.log 

rm _flow.png
mv ../../data/$file_/smali/android_apktool  ../../data/$file_/smali/apktool/android

cd ../../





