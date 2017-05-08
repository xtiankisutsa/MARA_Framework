Androwarn
=========
Yet another static code analyzer for malicious Android applications
====================================================

Description
-----------
Androwarn is a tool whose main aim is to detect and warn the user about potential malicious behaviours developped by an Android application.

The detection is performed with the static analysis of the application's Dalvik bytecode, represented as Smali.

This analysis leads to the generation of a report, according to a technical detail level chosen from the user.


Features
--------
* Structural and data flow analysis of the bytecode targeting different malicious behaviours categories
	+ **Telephony identifiers exfiltration**: IMEI, IMSI, MCC, MNC, LAC, CID, operator's name...
	+ **Device settings exfiltration**: software version, usage statistics, system settings, logs...
	+ **Geolocation information leakage**: GPS/WiFi geolocation...
	+ **Connection interfaces information exfiltration**: WiFi credentials, Bluetooth MAC adress...
	+ **Telephony services abuse**: premium SMS sending, phone call composition...
	+ **Audio/video flow interception**: call recording, video capture...
	+ **Remote connection establishment**: socket open call, Bluetooth pairing, APN settings edit...
	+ **PIM data leakage**: contacts, calendar, SMS, mails...
	+ **External memory operations**: file access on SD card...
	+ **PIM data modification**: add/delete contacts, calendar events...
	+ **Arbitrary code execution**: native code using JNI, UNIX command, privilege escalation...
	+ **Denial of Service**: event notification deactivation, file deletion, process killing, virtual keyboard disable, terminal shutdown/reboot...


* Report generation according to several detail levels
	- Essential (-v 1) for newbies
	- Advanced (-v 2)
	- Expert (-v 3)

* Report generation according to several formats
	- plaintext (TXT)
	- formatted text (HTML) from a Bootstrap template


Usage
-----
```
python androwarn.py -i my_application_to_be_analyzed.apk -r html -v 3
```
```python androwarn.py -h``` to see full options

By default, the report is generated in the `Report` folder

Example
-------
A sample application has been built, concentrating several malicious behaviours.

The APK is available in the `SampleApplication/bin/` folder and the HTML report is available in the `Report` folder.

The analysis report of a real malware `Android.Tigerbot`, known as `com.google.android.lifestyle` is also available in the same folder.


Installation
------------
1. Take a look at the Dependencies chapter and [install what's needed](https://github.com/maaaaz/androwarn/wiki/Installation)
2. Profit


Dependencies
------------
* python >= 2.6
* Jinja2 : http://pypi.python.org/pypi/Jinja2/
* Chilkat : https://www.chilkatsoft.com/python.asp 

Contributing
-------------
You're welcome, any help is appreciated :)


Contact
------
* Thomas Debize < tdebize at mail d0t com >
* Join #androwarn on Freenode

Copyright and license
---------------------
Androwarn is free software: you can redistribute it and/or modify it under the terms of the GNU Lesser General Public License as published by the Free Software Foundation, either version 3 of the License, or (at your option) any later version.

Androwarn is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. 

See the GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License along with Androwarn.  
If not, see http://www.gnu.org/licenses/.

Greetings
-------------
* [Stéphane Coulondre](http://scoulond.insa-lyon.fr), for supervising my Final Year project
* [Anthony Desnos](https://sites.google.com/site/anthonydesnos/home), for his amazing [Androguard](https://code.google.com/p/androguard) project and his help through my Final Year project
