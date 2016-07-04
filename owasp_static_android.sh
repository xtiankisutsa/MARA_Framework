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

#=====================
#OWASP Top 10 mobile 
#======================
	echo "=========================================="
	echo -e "${yellow} Performing OWASP Top 10 mobile Analysis ${no_color}"
	echo "=========================================="
#M1=Improper Platform Usage
echo -e "${no_color}[+] ${blue}M1-Improper Platform Usage"
#Android intents, platform permissions, misuse of TouchID, the Keychain,  

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Root Activity
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#Checking for dexguard root detection code
	echo -e "   ${no_color}[-] ${brown}Checking for dexguard root detection code"
	echo -e "\n==========================\ndexguard root detection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|RootDetector.isDeviceRooted' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|RootDetector.isDeviceRooted' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	
	#Checking if the app may request root/superuser privileges
	echo -e "   ${no_color}[-] ${brown}Checking for capability to request for root/superuser privileges"
	echo -e "\n==========================\nSuperuser request:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	grep -rE 'com.noshufou.android.su|com.thirdparty.superuser|eu.chainfire.supersu|com.koushikdutta.superuser|eu.chainfire.' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	grep -rE 'com.noshufou.android.su|com.thirdparty.superuser|eu.chainfire.supersu|com.koushikdutta.superuser|eu.chainfire.' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/root_activity.txt

	#Checking if the app may have root detection capabilities
	echo -e "   ${no_color}[-] ${brown}Checking for root detection capabilities"
	echo -e "\n==========================\nRoot detection capabilities:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	grep -rE 'test-keys|/system/app/Superuser.apk|isDeviceRooted|/system/bin/failsafe/su|/system/sd/xbin/su|"/system/xbin/which"|"su"|RootTools.isAccessGiven|/system/bin/su|/system/xbin/su' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/root_activity.txt
	grep -rE 'test-keys|/system/app/Superuser.apk|isDeviceRooted|/system/bin/failsafe/su|/system/sd/xbin/su|"/system/xbin/which"|"su"|RootTools.isAccessGiven|/system/bin/su|/system/xbin/su' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/root_activity.txt

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Dynamic Loading
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#Checking if the app can dynamically load classes
	echo -e "   ${no_color}[-] ${brown}Checking for dynamic class loading"
	echo -e "\n==========================\nDex class loader:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	grep -rE 'dalvik.system.DexClassLoader|java.security.ClassLoader|java.net.URLClassLoader|java.security.SecureClassLoader' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	grep -rE 'dalvik.system.DexClassLoader|java.security.ClassLoader|java.net.URLClassLoader|java.security.SecureClassLoader' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	
	#Checking if the app can load and manipulate Dex files
	echo -e "   ${no_color}[-] ${brown}Checking for Dex file loading and manipulation"
	echo -e "\n==========================\nLoad and Manipulate Dex Files:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	grep -rE 'dalvik.system.PathClassLoader|dalvik.system.DexFile|dalvik.system.DexPathList|dalvik.system.DexClassLoader|loadDex|loadClass|DexClassLoader|loadDexFile' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt
	grep -rE 'dalvik.system.PathClassLoader|dalvik.system.DexFile|dalvik.system.DexPathList|dalvik.system.DexClassLoader|loadDex|loadClass|DexClassLoader|loadDexFile' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/dynamic_loading.txt

	#Checking if the app executes system commands
	echo -e "   ${no_color}[-] ${brown}Checking for system commands execution"
	echo -e "\n==========================\nSystem command execution:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/system_commands.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/system_commands.txt
	grep -rE 'getRuntime().exec|getRuntime' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/system_commands.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/system_commands.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/system_commands.txt
	grep -rE 'getRuntime().exec|getRuntime' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/system_commands.txt
	echo " "

#M2=Insecure Data Storage
echo -e "${no_color}[+] ${blue}M2-Insecure Data Storage"

	#Checking if the app logs information
	echo -e "   ${no_color}[-] ${brown}Checking for app logging"
	echo -e "\n==========================\nSensitive information logging:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/app_logging.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/app_logging.txt
	grep -rE 'Log[.][vdiwe]|System.out.print' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/app_logging.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/app_logging.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/app_logging.txt
	grep -rE 'Log[.][vdiwe]|System.out.print' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/app_logging.txt
	echo -e "   ${light_red}[NOTE] ${brown}Sensitive information should never be logged"

	#Checking if the app uses SQLite Database
	echo -e "   ${no_color}[-] ${brown}Checking for SQLite Database usage"
	echo -e "\n==========================\nSQLite Database:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/SQLite_Database.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/SQLite_Database.txt
	grep -rE 'rawQuery|SQLiteDatabase|execSQL|android.database.sqlite' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/SQLite_Database.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/SQLite_Database.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/SQLite_Database.txt
	grep -rE 'rawQuery|SQLiteDatabase|execSQL|android.database.sqlite' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/SQLite_Database.txt
	echo -e "   ${light_red}[NOTE] ${brown}Sensitive information should be encrypted"

	#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Filesystem Access
	#+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#Checking if the Object is World Readable by any App.
	echo -e "   ${no_color}[-] ${brown}Checking for world readable objects"
	echo -e "\n==========================\nWorld readable objects:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	grep -rE 'MODE_WORLD_READABLE|Context.MODE_WORLD_READABLE' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	grep -rE 'MODE_WORLD_READABLE|Context.MODE_WORLD_READABLE' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt

	#Checking if the Object is World Writable by any app.
	echo -e "   ${no_color}[-] ${brown}Checking for world writeable objects"
	echo -e "\n==========================\nWorld writeable objects:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	grep -rE 'MODE_WORLD_WRITABLE|Context.MODE_WORLD_WRITABLE' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	grep -rE 'MODE_WORLD_WRITABLE|Context.MODE_WORLD_WRITABLE' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	
	#Checking if app can write to app directory. .
	echo -e "   ${no_color}[-] ${brown}Checking for own directory writing capability"
	echo -e "\n==========================\nWrite to app directory:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	grep -rE 'MODE_private_ip|Context.MODE_private_ip' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	grep -rE 'MODE_private_ip|Context.MODE_private_ip' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo -e "   ${light_red}[NOTE] ${brown}Sensitive information should be encrypted"
	echo " " >> data/$file_/analysis/static/vulnerabilities/filesystem_access.txt
	echo " "

#M3=Insecure Communication
echo -e "${no_color}[+] ${blue}M3-Insecure Communication"
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Network Communication
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Checking if the app URL can connect to http/https/ftp/jar
	echo -e "   ${no_color}[-] ${brown}Checking for capability to connect to http/https/ftp/jar"
	echo -e "\n==========================\nURL network_communication to file/http/https/ftp/jar:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'net.URL|openStream' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'net.URL|openStream' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt

	#Checking if the app URL can connect to JAR url
	echo -e "   ${no_color}[-] ${brown}Checking for capability to connect to JAR url"
	echo -e "\n==========================\nJAR URL network_communication:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'net.JarURL|JarURL|jar:' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'net.JarURL|JarURLnetwork_communication:' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	
	#Checking if the app initiate HTTP network_communications
	echo -e "   ${no_color}[-] ${brown}Checking for capability to initiate HTTP network_communications"
	echo -e "\n==========================\nHTTP network_communication:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'HttpURL|org.apache.http|HttpRequest' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'HttpURL|org.apache.http|HttpRequest' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	
	#Checking if the app URL can initiate a HTTPS network_communication
	echo -e "   ${no_color}[-] ${brown}Checking for capability to initiate HTTPS network_communications"
	echo -e "\n==========================\nHTTPS network_communication:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'javax.net.ssl.HttpsURL|HttpsURL' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'javax.net.ssl.HttpsURL|HttpsURL' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	
	#Checking if the app facilitates HTTP Requests, network_communications and Sessions 
	echo -e "   ${no_color}[-] ${brown}Checking for capability to initialize HTTP Requests, network_communications and Sessions" 
	echo -e "\n==========================\nHTTP Requests,network_communications and Sessions:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'http.client.HttpClient|net.http.AndroidHttpClient|http.impl.client.AbstractHttpClient' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'http.client.HttpClient|net.http.AndroidHttpClient|http.impl.client.AbstractHttpClient' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Webview Implementation and Javascript
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#Checking if the app uses Webkit
	echo -e "   ${no_color}[-] ${brown}Checking for webkit Implementation"
	echo -e "\n==========================\nWebKit Implementation:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE 'android.webkit' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE 'android.webkit' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	
	#Checking if the app uses WebView and can load HTML/JavaScript 
	echo -e "   ${no_color}[-] ${brown}Checking for webView load HTML/JavaScript capability"
	echo -e "\n==========================\nWebView Load HTML/JavaScript:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE 'loadData' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE 'loadData' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	
	#Insecure WebView Implementation. 
	echo -e "   ${no_color}[-] ${brown}Checking for insecure webView implementation (Javascript_interface)"
	echo -e "\n==========================\nInsecure webView implementation (Javascript_interface):\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE 'setJavaScriptEnabled|.addJavascriptInterface' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE 'setJavaScriptEnabled|.addJavascriptInterface' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo -e "   ${light_red}[NOTE] ${brown}Execution of user controlled code in WebView is a critical Security Hole"
	
	#Checking if remote WebView debugging is enabled
	echo -e "   ${no_color}[-] ${brown}Checking for remote WebView debugging"
	echo -e "\n==========================\nRemote webview enabled:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE '.setWebContentsDebuggingEnabled(true)' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE '.setWebContentsDebuggingEnabled(true)' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	
	#Checking if the app can perform WebView POST Request
	echo -e "   ${no_color}[-] ${brown}Checking for webView POST request capability"
	echo -e "\n==========================\nWebView POST Request:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'postUrl' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'postUrl' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " "

#M5=Insufficient Cryptography
echo -e "${no_color}[+] ${blue}M5-Insufficient Cryptography"

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Crypto Implementation
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#Checking if the app uses crypto
	echo -e "   ${no_color}[-] ${brown}Checking for crypto usage"
	echo -e "\n==========================\nCrypto:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'javax.crypto|kalium.crypto|bouncycastle.crypto' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'javax.crypto|kalium.crypto|bouncycastle.crypto' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	
	#Checking for SSL pinning libraries
	echo -e "   ${no_color}[-] ${brown}Checking for SSL pinning libraries"
	echo -e "\n==========================\nSSL pinning detection:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'org.thoughtcrime.ssl.pinning|PinningHelper.getPinnedHttpsURLConnection|PinningHelper.getPinnedHttpClient|PinningSSLSocketFactory' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'org.thoughtcrime.ssl.pinning|PinningHelper.getPinnedHttpsURLConnection|PinningHelper.getPinnedHttpClient|PinningSSLSocketFactory' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo -e "   ${light_red}[NOTE] ${brown}SSL pinning helps prevent MITM attacks over secure communication (https)"
	echo " "

#M8=Code Tampering
echo -e "${no_color}[+] ${blue}M8-Code Tampering"

	#Checking if the app uses java reflection
	echo -e "   ${no_color}[-] ${brown}Checking for Java reflection"
	echo -e "\n==========================\nJava reflection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/java_reflection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/java_reflection.txt
	grep -rE 'java.lang.reflect.Method|java.lang.reflect.Field|Class.forName' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/java_reflection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/java_reflection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/java_reflection.txt
	grep -rE 'java.lang.reflect.Method|java.lang.reflect.Field|Class.forName' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/java_reflection.txt
	
	#Checking for dexguard tamper detection code
	echo -e "   ${no_color}[-] ${brown}Checking for dexguard tamper detection code"
	echo -e "\n==========================\ndexguard tamper detection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|TamperDetector.checkApk' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|TamperDetector.checkApk' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt

	#Checking for dexguard signer certificate tamper detection code
	echo -e "   ${no_color}[-] ${brown}Checking for dexguard signer certificate tamper detection code"
	echo -e "\n==========================\ndexguard signer certificate tamper detection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|CertificateChecker.checkCertificate' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|CertificateChecker.checkCertificate' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " "

#M9=Reverse Engineering
echo -e "${no_color}[+] ${blue}M9-Reverse Engineering"

	#Checking for dexguard tamper detection code
	echo -e "   ${no_color}[-] ${brown}Checking for dexguard tamper detection code"
	echo -e "\n==========================\ndexguard tamper detection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|TamperDetector.checkApk' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|TamperDetector.checkApk' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	
	#Checking for dexguard signer certificate tamper detection code
	echo -e "   ${no_color}[-] ${brown}Checking for dexguard signer certificate tamper detection code"
	echo -e "\n==========================\ndexguard signer certificate tamper detection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|CertificateChecker.checkCertificate' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|CertificateChecker.checkCertificate' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	
	#Checking for Checking for dexguard debugger detection code
	echo -e "   ${no_color}[-] ${brown}Checking for dexguard debugger detection code"
	echo -e "\n==========================\ndexguard debug detection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|DebugDetector.isDebuggerConnected' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'dexguard.util|sDebugDetector.isDebuggable' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo -e "   ${light_red}[NOTE] ${brown}This code is used to detect whether the app is attached to a debugger"
	
	#Checking for Checking for dexguard emulator  detection code
	echo -e "   ${no_color}[-] ${brown}Checking for dexguard emulator detection code"
	echo -e "\n==========================\ndexguard debug detection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|EmulatorDetector.isRunningInEmulator' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'dexguard.util|sDebugDetector.isDebuggable' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo -e "   ${light_red}[NOTE] ${brown}This code is used to detect whether the app is running in an emulator"
	
	#echo -e "   ${no_color}[-] ${brown}Checking for dexguard code to detect wheather the app is signed with a debug key or not
	echo -e "   ${no_color}[-] ${brown}Checking for dexguard debug key code"
	echo -e "\n==========================\ndexguard debug key:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|EDebugDetector.isSignedWithDebugKey' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'import dexguard.util|EDebugDetector.isSignedWithDebugKey' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo -e "   ${light_red}[NOTE] ${brown}This code to detect whether the app is signed with a debug key${no_color}"
	echo " "

#=======================================
#Performing OWASP mobile Analysis - stage 2 
#=======================================
echo "============================================="
echo -e "${yellow} Performing OWASP mobile Analysis - stage 2 ${no_color}"
echo "============================================="

#P1=Lack of Code Protection
echo -e "${no_color}[+] ${blue}Lack of Code Protection"

	#Checking if the app contains native java code"
	echo -e "   ${no_color}[-] ${brown}Checking for native java code"
	echo -e "\n==========================\nNative jave code:\n==========================\n" >> data/$file_/analysis/static/general_analysis/java_code.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/java_code.txt
	grep -rE 'java.lang.System|java.lang.Runtime' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/java_code.txt
	echo " " >> data/$file_/analysis/static/general_analysis/java_code.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/java_code.txt
	grep -rE 'java.lang.System|java.lang.Runtime' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/java_code.txt

	#Checking if the app uses obfuscation
	echo -e "   ${no_color}[-] ${brown}Checking for native java code"
	echo -e "\n==========================\nObfuscation:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'utils.AESObfuscator|getObfuscator' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'utils.AESObfuscator|getObfuscator' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " "

#P2=Hard coded sensitive information in Application Code (including Crypto)

	#Checking if the app contain hardcoded sensitive informations like usernames, passwords, keys etc
	echo -e "${no_color}[+] ${blue}Hard coded sensitive information in Application Code (including Crypto)"
	echo -e "\n==========================\nHardcoded info:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/hardcoded_info.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/hardcoded_info.txt
	grep -irE 'password =|secret =|username =|key =' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/hardcoded_info.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/hardcoded_info.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/hardcoded_info.txt
	grep -irE 'password =|secret =|username =|key =' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/hardcoded_info.txt
	echo " "

#P3=Application makes use of Weak Cryptography
echo -e "${no_color}[+] ${blue}Application makes use of Weak Cryptography"
	#Checking if the app uses message digest"
	echo -e "   ${no_color}[-] ${brown}Checking capability to use message digest" 
	echo -e "\n==========================\nMessage Digest:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'java.security.MessageDigest|.MessageDigestSpi|MessageDigest' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'java.security.MessageDigest|.MessageDigestSpi|MessageDigest' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt

	#Checking if the app uses an insecure Random Number Generator
	echo -e "   ${no_color}[-] ${brown}Checking for insecure random number generator usage"
	echo -e "\n==========================\nInsecure random number generator:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'java.util.Random' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'java.util.Random' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " "

#P4=SSL implementation 
echo -e "${no_color}[+] ${blue}SSL implementation"

	#Checking for insecure SSL implementation
	echo -e "   ${no_color}[-] ${brown}Checking for insecure SSL implementation"
	echo -e "\n==========================\nInsecure SSL implementation:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'javax.net.ssl|TrustAllSSLSocket-Factory|AllTrustSSLSocketFactory|NonValidatingSSLSocketFactory|ALLOW_ALL_HOSTNAME_VERIFIER|.setDefaultHostnameVerifier|NullHostnameVerifier' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'javax.net.ssl|TrustAllSSLSocket-Factory|AllTrustSSLSocketFactory|NonValidatingSSLSocketFactory|ALLOW_ALL_HOSTNAME_VERIFIER|.setDefaultHostnameVerifier|NullHostnameVerifier' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo -e "   ${light_red}[NOTE] ${brown}Trusting all the certificates or accepting self signed certificates is a critical security hole"
	
	#Checking for insecure webview implementation due to certificate errors
	echo -e "   ${no_color}[-] ${brown}Checking for insecure webview implementation (Certificate errors)"
	echo -e "\n==========================\nInsecure webView implementation (Certificate errors):\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE 'onReceivedSslError|.proceed' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt
	grep -rE 'onReceivedSslError|.proceed' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/webview_implementation.txt

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#SSL Implementation 
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	
	function scan_domain(){
	echo -e "   ${no_color}[-] ${brown}Enter domain to scan:${no_color}" 
	read domain	
	export domain
	echo $domain > data/$file_/analysis/static/ssl_scan/domain.txt 
	echo -e "   ${no_color}[-] ${brown}Scanning ${blue}$domain ${brown}in the background...please be patient!!${no_color}"
	#pyssltest
	nohup ./ssl_pyssltest.sh > /dev/null 2>>data/$file_/analysis/static/ssl_scan/logs/pyssltest_errors.log &
	#testssl 
	nohup ./ssl_testssl.sh > /dev/null 2>>data/$file_/analysis/static/ssl_scan/logs/testssl_errors.log &
	}

	#This is the code for scanning domains
	echo -e "   ${no_color}[-] ${brown}Preparing domain SSL scan${no_color}"
	#echo -e "   ${light_red}[NOTE] ${brown}No IP address scanning! Only domains! ${no_color}"
	echo -e "   ${no_color}[-] ${brown}Extracting domains from source files${no_color}"
	#echo "Extracting domains from source files"
	grep -rEo '(http|https|ftp|ftps)://[^/\n ]*' data/$file_/source/jadx | cut -d ':' -f 2-3 | sort -u | sed "s/^/       /" 
	#Ask if they want to scan domain
	echo -e "   ${no_color}[-] ${brown}Scan domain? (yes/no)"
	echo -e "   ${light_red}[NOTE] ${brown}Domain scanning takes about 2 minutes! ${no_color}"
	read input

	if [ $input == 'yes' ] || [ $input == 'y' ] ; then 
		scan_domain	
	elif
		[ $input == 'no' ] || [ $input == 'n' ] ; then 
		echo -e "   ${light_red}[NOTE] ${brown}Skipped domain scanning!!"	
	else

		if ! [ $input == 'yes' ] || ! [ $input == 'no' ] ; then 
			echo -e "   ${light_red}[NOTE] ${brown}Invalid response!!"	
		fi
	fi	

	echo " "

#P7=Insecure application permissions
echo -e "${no_color}[+] ${blue}Insecure application permissions"

	#Checking if the app queries Database of SMS, Contacts etc.
	echo -e "   ${no_color}[-] ${brown}Checking for capability to query databases"
	echo -e "\n==========================\nDatabase query:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/database.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/database.txt
	grep -rE 'content.ContentResolver' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/database.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/database.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/database.txt
	grep -rE 'content.ContentResolver' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/database.txt

	#Checking if the app gets system services"
	echo -e "   ${no_color}[-] ${brown}Checking for capability to request for system services"
	echo -e "\n==========================\nSystem services:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/system_service.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/system_service.txt
	grep -rE 'getSystemService' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/system_service.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/system_service.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/system_service.txt
	grep -rE 'getSystemService' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/system_service.txt

	#Checking if the app performs local file I/O operations
	echo -e "   ${no_color}[-] ${brown}Checking capability to perform local file I/O operations"
	echo -e "\n==========================\nLocal file I/O operations:\n==========================\n" >> data/$file_/analysis/static/general_analysis/IO_operations.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/IO_operations.txt
	grep -rE 'OpenFileOutput|getSharedPreferences|SharedPreferences.Editor|getCacheDir|getExternalStorageState|openOrCreateDatabase' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/IO_operations.txt
	echo " " >> data/$file_/analysis/static/general_analysis/IO_operations.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/IO_operations.txt
	grep -rE 'OpenFileOutput|getSharedPreferences|SharedPreferences.Editor|getCacheDir|getExternalStorageState|openOrCreateDatabase' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/IO_operations.txt

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Device Details
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Checking if the app gets Device Info
	echo -e "   ${no_color}[-] ${brown}Checking for Device info request"
	echo -e "\n==========================\nDevice Info:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/device_details.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/device_details.txt
	grep -rE 'getSubscriberId|getDeviceId|getDeviceSoftwareVersion' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/device_details.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/device_details.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/device_details.txt
	grep -rE 'getSubscriberId|getDeviceId|getDeviceSoftwareVersion' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/device_details.txt

	#Checking if the app gets SIM data
	echo -e "   ${no_color}[-] ${brown}Checking for SIM info request"
	echo -e "\n==========================\nSIM info:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/device_details.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/device_details.txt
	grep -rE 'getSimSerialNumber|getSimOperator|getSimOperatorName' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/device_details.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/device_details.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/device_details.txt
	grep -rE 'getSimSerialNumber|getSimOperator|getSimOperatorName' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/device_details.txt

	#Checking if the app accesses telphony
	echo -e "   ${no_color}[-] ${brown}Checking for telephony access"
	echo -e "\n==========================\ntelephony access:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/telephony_access.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/telephony_access.txt
	grep -rE 'telephony.TelephonyManager' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/telephony_access.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/telephony_access.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/telephony_access.txt
	grep -rE 'telephony.TelephonyManager' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/telephony_access.txt

	#Checking if the app can send SMS
	echo -e "   ${no_color}[-] ${brown}Checking for capability to send SMS/MMS"
	echo -e "\n==========================\nSend SMS:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/sms_mms.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/sms_mms.txt
	grep -rE 'sendMultipartTextMessage|sendTextMessage|vnd.android-dir/mms-sms|telephony.SmsManager' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/sms_mms.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/sms_mms.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/sms_mms.txt
	grep -rE 'sendMultipartTextMessage|sendTextMessage|vnd.android-dir/mms-sms|telephony.SmsManager' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/sms_mms.txt

	#Checking if the app sends out Android Notifications
	echo -e "   ${no_color}[-] ${brown}Checking for notification capability" 
	echo -e "\n==========================\nAndroid notifications:\n==========================\n" >> data/$file_/analysis/static/general_analysis/notification.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/notification.txt
	grep -rE 'app.NotificationManager' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/notification.txt
	echo " " >> data/$file_/analysis/static/general_analysis/notification.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/notification.txt
	grep -rE 'app.NotificationManager' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/notification.txt

	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	#Location Services
	#++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

	#Checking if the app gets Cell information
	echo -e "   ${no_color}[-] ${brown}Checking for cell information request"
	echo -e "\n==========================\nCell information:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	grep -rE 'getAllCellInfo' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	grep -rE 'getAllCellInfo' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/location_services.txt
	
	#Checking if the app gets Cell location"
	echo -e "   ${no_color}[-] ${brown}Checking for cell location request"
	echo -e "\n==========================\nCell location:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	grep -rE 'getCellLocation' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	grep -rE 'getCellLocation' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/location_services.txt
	
	#Checking if the app gets GPS location
	echo -e "   ${no_color}[-] ${brown}Checking for GPS location request"
	echo -e "\n==========================\nGPS location:\n==========================\n" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo "Jadx:" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	grep -rE 'android.location|getLastKnownLocation|requestLocationUpdates|getLatitude|getLongitude' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo " " >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo "Java:" >> data/$file_/analysis/static/malicious_activity/location_services.txt
	grep -rE 'android.location|getLastKnownLocation|requestLocationUpdates|getLatitude|getLongitude' data/$file_/source/java | sort -u >> data/$file_/analysis/static/malicious_activity/location_services.txt
	echo " "

#P9=Private IP Disclosure

	#This does not seem to work
	#Dump any private IP addresses
	echo -e "${no_color}[+] ${blue}Private IP Disclosure"
	echo -e "\n==========================\nPrivate IP:\n==========================\n"  >> data/$file_/analysis/static/vulnerabilities/private_ip.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/private_ip.txt
	grep -rE '(^127\.)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)' data/$file_/source/jadx >> data/$file_/analysis/static/vulnerabilities/private_ip.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/private_ip.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/private_ip.txt
	grep -rE '(^127\.)|(^10\.)|(^172\.1[6-9]\.)|(^172\.2[0-9]\.)|(^172\.3[0-1]\.)|(^192\.168\.)' data/$file_/source/java >> data/$file_/analysis/static/vulnerabilities/private_ip.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/private_ip.txt
	echo " "


#=======================================
#OWASP Mobile checks - android only
#=======================================

#A1=Debug is set to TRUE

	echo -e "${no_color}[+] ${blue}Checking for dexguard debug detection code"
	echo -e "\n==========================\ndexguard debug detection:\n==========================\n" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'dexguard.util|sDebugDetector.isDebuggable' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo " " >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	grep -rE 'dexguard.util|sDebugDetector.isDebuggable' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/anti-tamper_protection.txt
	echo -e "   ${light_red}[NOTE] ${brown}This code is used to detect whether the app is debuggable${no_color}"
	echo " "

#A2=Android Backup Vulnerability
#A3=Failure to Implement Trusted Issuers
#A4=Allow All Hostname Verifier
#A5=Weak Custom Hostname Verifier
#A6=Redundancy Permission Granted
#A7=Activity Hijacking


#A8=Service Hijacking
echo -e "${no_color}[+] ${blue}Service Hijacking"

	#Checking if the app can communicate with other processes
	echo -e "   ${no_color}[-] ${brown}Checking for Inter Process Communication(IPC)"
	echo -e "\n==========================\nInter process communication:\n==========================\n" >> data/$file_/analysis/static/general_analysis/inter_process_comm.txt
	echo "Jadx:" >> data/$file_/analysis/static/general_analysis/inter_process_comm.txt
	grep -rE 'IRemoteService|IRemoteService.Stub|IBinder' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/general_analysis/inter_process_comm.txt
	echo " " >> data/$file_/analysis/static/general_analysis/inter_process_comm.txt
	echo "Java:" >> data/$file_/analysis/static/general_analysis/inter_process_comm.txt
	grep -rE 'IRemoteService|IRemoteService.Stub|IBinder' data/$file_/source/java | sort -u >> data/$file_/analysis/static/general_analysis/inter_process_comm.txt
	echo " "

#A9=Broadcast Thief
	#Checking if the app sends broadcasts
	echo -e "${no_color}[+] ${blue}Checking for capability to send broadcasts"
	echo -e "\n==========================\nSend broadcasts:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	grep -rE 'sendBroadcast|sendOrderedBroadcast|sendStickyBroadcast' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	grep -rE 'sendBroadcast|sendOrderedBroadcast|sendStickyBroadcast' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo " "

#A10=Malicious Broadcast Injection


#A11=Malicious Activity/Service Launch
echo -e "${no_color}[+] ${blue}Malicious Activity/Service Launch"

	#Checking if the app starts activties"
	echo -e "   ${no_color}[-] ${brown}Checking for capability to starts activties"
	echo -e "\n==========================\nStarting activities:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	grep -rE 'startActivity\(|startActivityForResult' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	grep -rE 'startActivity\(|startActivityForResult' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	
	#Checking if the app starts services"
	echo -e "   ${no_color}[-] ${brown}Checking if the app starts services"
	echo -e "\n==========================\nStarting services:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	grep -rE 'startService|bindService' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	grep -rE 'startService|bindService' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/activities_services_broadcasts.txt
	echo " "

#A12=Insecure permissions on Unix domain sockets


#A13=Insecure use of network sockets
echo -e "${no_color}[+] ${blue}Insecure use of network sockets"

	#Checking if the app opens TCP Server Sockets
	echo -e "   ${no_color}[-] ${brown}Checking for capability to open TCP Server Sockets"
	echo -e "\n==========================\nTCP Server Socket:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'ServerSocket|net.ServerSocket|connect[(][)]' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'ServerSocket|net.ServerSocket|connect[(][)]' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	
	#Checking if the app can open UDP Datagram Sockets
	echo -e "   ${no_color}[-] ${brown}Checking for capability to open UDP Datagram Sockets"
	echo -e "\n==========================\nUDP Datagram Socket:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'DatagramSocket|net.DatagramSocket' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	grep -rE 'DatagramSocket|net.DatagramSocket' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/network_communication.txt
	echo " "

#A14=Application makes use of encoding 
echo -e "${no_color}[+] ${blue}Application makes use of encoding/decoding"

#Checking if the app uses Base64 encoding"
	echo -e "   ${no_color}[-] ${brown}Checking for Base64 encoding/decoding"
	echo -e "\n==========================\nBase64 Encode:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'android.util.Base64|.encodeToString|.encode' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'android.util.Base64|.encodeToString|.encode' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	
	#Checking if the app uses Base64 decoding"
	echo -e "   ${no_color}[-] ${brown}Checking for Base64 decoding${no_color}"
	echo -e "\n==========================\nBase64 Decode:\n==========================\n" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Jadx:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'android.util.Base64|.decode' data/$file_/source/jadx | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " " >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo "Java:" >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	grep -rE 'android.util.Base64|.decode' data/$file_/source/java | sort -u >> data/$file_/analysis/static/vulnerabilities/crypto_implementation.txt
	echo " "

