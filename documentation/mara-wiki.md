#MARA Framework wiki

##Introduction
**MARA** is a **M**obile **A**pplication **R**everse engineering and **A**nalysis Framework. It is a tool that puts together commonly used mobile application reverse engineering and analysis tools, to assist in testing mobile applications against the OWASP mobile security threats. Its objective is to make this task easier and friendlier to mobile application developers and security professionals. 

##Features supported
###APK Reverse Engineering
* Disassembling Dalvik bytecode to smali bytecode via [baksmali](https://bitbucket.org/JesusFreke/smali/downloads) and [apktool](https://ibotpeaches.github.io/Apktool/install/)
* Disassembling Dalvik bytecode to java bytecode via [enjarify](https://github.com/google/enjarify)
* Decompiling APK to Java source code via [jadx](https://github.com/skylot/jadx) 

###Preliminary Analsyis
* Parsing smali files for analysis via [smalisca](https://github.com/dorneanu/smalisca) 
* Dump apk assets,libraries and resources
* Extracting certificate data via [openssl](https://github.com/openssl/openssl)
* Extract strings and app permissions via aapt
* Identify methods and classes via [ClassyShark](https://github.com/google/android-classyshark)
* Scan for apk vulnerabilities via [androbugs](https://github.com/AndroBugs/AndroBugs_Framework)
* Analyze apk for potential malicious behaviour via [androwarn](https://github.com/maaaaz/androwarn)
* Identify compilers, packers and obfuscators via [APKiD](https://github.com/rednaga/APKiD)
* Extract execution paths, IP addresses, URL, URI, emails via regex
* Domain SSL scan via [pyssltest](https://github.com/moheshmohan/pyssltest) and [testssl](https://github.com/drwetter/testssl.sh) 

###APK Manifest Analysis
* Extract Intents
* Extract exported activities
* Extract receivers
* Extract exported receivers
* Extract Services
* Extract exported services
* Check if apk is debuggable
* Check if apk allows backups
* Check if apk allows sending of secret codes
* Check if apk can receive binary SMS

###Security Analysis
* Source code static analysis based on [OWASP Top Mobile Top 10](https://www.owasp.org/index.php/Mobile_Top_10_2016-Top_10) and the [OWASP Mobile Apps Checklist](https://drive.google.com/file/d/0BxOPagp1jPHWYmg3Y3BfLVhMcmc/view)

##Installing MARA on Linux/Nethunter
The following are the requirements for running MARA. The domain SSL scanning component requires an active internet connection. MARA works with Open JDK or Oracle JDK. We recommend version 7 and above when using either of them. 
#### Java JDK
    sudo apt-get -y install openjdk-7-jdk 

#### Git
    sudo apt-get -y install git

#### Tree
    sudo apt-get -y install tree

#### Install 32bit libs
    sudo dpkg --add-architecture i386
    sudo apt-get update
    sudo apt-get -y install libgtk2.0-0:i386 libxxf86vm1:i386 libsm6:i386 lib32stdc++6

#### Figlet
    sudo apt-get -y install figlet
    sudo cp tools/figlet/doom.flf /usr/share/figlet

#### Unirest
    sudo pip install unirest

#### AHA - Ansi HTML Adapter
    sudo apt-get -y install aha

#### Python3
    sudo apt-get -y install python3

#### Androwarn dependencies
    sudo apt-get -y install python python-jinja2 git

#### Smali graph generation dependency
    sudo pip install pydot

#### Smalisca
    sudo pip install configparser
    sudo pip install smalisca

###Downloading MARA
* git clone --recursive https://github.com/xtiankisutsa/MARA_Framework

###Updating MARA
* cd MARA_Framework
* git pull https://github.com/xtiankisutsa/MARA_Framework
* ./setup.sh

MARA ships with a script that assists in downloading and installing the dependencies above. Simply run the **setup.sh** script with sudo privilege and it will install them. You will also need to re-run this script when you update MARA. 

After meeting all the requirements. If you run **./mara.sh** --help you should see the MARA help menu as shown below.

![](https://raw.githubusercontent.com/xtiankisutsa/MARA_Framework/master/documentation/help.png)

All the analysis data and file conversions are stored in the data folder i.e. **/MARA_Framework/data/file_name**. MARA also keeps a compressed copy of the analysis in the data folder i.e **/MARA_Framework/data/file_name.zip**. All the tools included in the Framework can be used standalone, they are all available in the tools folder i.e. **/MARA_Framework/tools**.

###SSL Scanner
MARA ships with a SSL scanner script that makes use of pyssltest and testssl. The stand alone SSL scanner can be run using the command **./ssl_scanner.sh** and follow the instructions displayed. The findings from the scan are dumped in the domain scans folder i.e. **/MARA_Framework/data/domain_scans/<domain_name>**. Please note that pyssltest scanner is intended to be used for scanning domains with SSL enabled. Do not scan IP addresses. 

While analyzing APK files, MARA provides the option of scanning domains found in the apk using the above mentioned tools. This scan runs in the background and can be skipped. In the event the scan is performed, the user is required to tail the two log files i.e **pyssltest.log** and **testssl.log** in **/MARA_Framework/data/apk_name/analysis/static/ssl_scan/log/**

###Smali control flow graphs
MARA is capable of generating control flow graphs from smali code. This is achieved by utilizing Smali-CFGs. The graph generation is optional and can be time consuming depending on the size of the android app being analyzed. The graphs are stored in two folders i.e. **apktool_cfg** and **baksmali_cfg** respectively in the location **/MARA_Framework/data/apk_name/smali/**

The graph generation runs in the background and you can check its completion by tailing the log files **apktool_cfg.log** and **baksmali_cfg.log** in the location mentioned above. 

##To do list
MARA is still in the very early stages of development. We intend to work on the following features: 
* Integrate dynamic mobile application analysis
* Rewrite the MARA Framework in python
* Integrate iOS, Blackberry and Windows phone application analysis
* Develop web panel to display data
* Include additional disassembly and analysis tools 

##Credits
These are the people who have assisted in ensuring the success of this tool's capabilities. 
* Chrispus - [@iamckn](https://twitter.com/iamckn) -[https://www.ckn.io](https://www.ckn.io) (co-developer)
* Ajin - [@ajinabraham](https://twitter.com/ajinabraham) - [Mobile Security Framework - MobSF](https://github.com/ajinabraham/Mobile-Security-Framework-MobSF)
* Munir - [@muntopia](https://twitter.com/muntopia) - http://munir.skilledsoft.com/
* Gabby - [@_V1VI](https://twitter.com/_V1VI)- https://thevivi.net
* AfricaHackOn Team - @AfricaHackon - http://africahackon.com

##Contributors
* Charles - [@icrackthecode](https://twitter.com/icrackthecode) - [https://github.com/icrackthecode]

##Disclaimer
MARA Framework is intended to be used for ethical hacking and educational purposes. Ensure consent is provided to allow reverse engineering of the various mobile applications as well as the scanning and interaction with the identified domains/IP addresses. 

##Licensing
MARA framework is intended to be free to use by anyone. It is available here on github for contribution and collaboration. The tool is currently licensed under GNU GPL v3 license to allow interested users to copy, distribute and adapt it, provided that the work is attributed to the creators of the framework.

##Copyright
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
