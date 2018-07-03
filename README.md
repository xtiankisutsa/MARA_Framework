# MARA_Framework
**MARA** is a **M**obile **A**pplication **R**everse engineering and **A**nalysis Framework. It is a tool that puts together commonly used mobile application reverse engineering and analysis tools, to assist in testing mobile applications against the OWASP mobile security threats. Its objective is to make this task easier and friendlier to mobile application developers and security professionals. 

**MARA** is developed and maintained by [@xtian_kisutsa](https://twitter.com/xtian_kisutsa) and [@iamckn](https://twitter.com/iamckn). It is in its very early stages of development and there is a lot more to come, in line with our roadmap. Any contributions and suggestions to the tool will be highly appreciated. 

![Alt](https://cloud.githubusercontent.com/assets/7021125/16489073/68e8faec-3edc-11e6-89f1-c403523e1338.png)

## Features supported
### APK Reverse Engineering
* Disassembling Dalvik bytecode to smali bytecode via [baksmali](https://bitbucket.org/JesusFreke/smali/downloads) and [apktool](https://ibotpeaches.github.io/Apktool/install/)
* Disassembling Dalvik bytecode to java bytecode via [enjarify](https://github.com/google/enjarify)
* Decompiling APK to Java source code via [jadx](https://github.com/skylot/jadx) 

### APK Deobfuscation
* APK deobfuscation via [apk-deguard.com] (http://www.apk-deguard.com/)

### APK Analysis
* Parsing smali files for analysis via [smalisca](https://github.com/dorneanu/smalisca) 
* Dump apk assets,libraries and resources
* Extracting certificate data via [openssl](https://github.com/openssl/openssl)
* Extract strings and app permissions via aapt
* Identify methods and classes via [ClassyShark](https://github.com/google/android-classyshark)
* Scan for apk vulnerabilities via [androbugs](https://github.com/AndroBugs/AndroBugs_Framework)
* Analyze apk for potential malicious behaviour via [androwarn](https://github.com/maaaaz/androwarn)
* Identify compilers, packers and obfuscators via [APKiD](https://github.com/rednaga/APKiD)
* Extract execution paths, IP addresses, URL, URI, emails via regex

### APK Manifest Analysis
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

### Domain Analysis
* Domain SSL scan via [pyssltest](https://github.com/moheshmohan/pyssltest) and [testssl](https://github.com/drwetter/testssl.sh) 
* Website fingerprinting via [whatweb](https://github.com/urbanadventurer/WhatWeb)

### Security Analysis
* Source code static analysis based on [OWASP Top Mobile Top 10](https://www.owasp.org/index.php/Mobile_Top_10_2016-Top_10) and the [OWASP Mobile Apps Checklist](https://drive.google.com/file/d/0BxOPagp1jPHWYmg3Y3BfLVhMcmc/view)
* MARA is capable of performing either **single** or **mass** analysis of apk, dex or jar files. 

Additional information about the framework, prerequisites and the installation guide is available on the [wiki](https://github.com/xtiankisutsa/MARA_Framework/wiki)


