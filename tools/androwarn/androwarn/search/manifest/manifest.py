#!/usr/bin/env python
# -*- coding: utf-8 -*-

# This file is part of Androwarn.
#
# Copyright (C) 2012, Thomas Debize <tdebize at mail.com>
# All rights reserved.
#
# Androwarn is free software: you can redistribute it and/or modify
# it under the terms of the GNU Lesser General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Androwarn is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with Androwarn.  If not, see <http://www.gnu.org/licenses/>.

# Global imports
import re, logging

# Androguard imports
from androguard.core.analysis import analysis
from androguard.core.bytecodes.apk import *
from xml.dom import minidom

# Androwarn modules import
from androwarn.core.core import *
from androwarn.constants.api_constants import *
from androwarn.util.util import *

# Logguer
log = logging.getLogger('log')

def grab_main_activity(apk) :
	"""
		@param apk : an APK instance
		
		@rtype : the name of the main activity
	"""
	return apk.get_main_activity()

def grab_activities(apk) :
	"""
		@param apk : an APK instance
	
		@rtype : the android:name attribute of all activities
	"""
	return apk.get_elements("activity", "android:name")

def grab_services(apk) :
	"""
		@param apk : an APK instance
		
		@rtype : the android:name attribute of all services
	"""
	return apk.get_elements("service", "android:name")

def grab_receivers(apk) :
	"""
		@param apk : an APK instance
	
		@rtype : the android:name attribute of all receivers
	"""
	return apk.get_elements("receiver", "android:name")

def grab_providers(apk) :
	"""
		@param apk : an APK instance
	
		@rtype : the android:name attribute of all providers
	"""
	return apk.get_elements("provider", "android:name")

def grab_permissions(apk) :
	"""
		@param apk : an APK instance
		
		@rtype : a list of permissions
	"""
	return apk.get_permissions()

def grab_features(apk) :
	"""
		@param apk : an APK instance
	
		@rtype : a list of features
	"""
	features = []
	xml = {}
	for i in apk.zip.namelist() :
		if i == "AndroidManifest.xml" :
			xml[i] = minidom.parseString( AXMLPrinter( apk.zip.read( i ) ).getBuff() )
			for item in xml[i].getElementsByTagName('uses-feature') :
				features.append( str( item.getAttribute("android:name") ) )
	return features

def grab_libraries(apk) :
	"""
		@param apk : an APK instance
	
		@rtype : the libraries' names
	"""
	return apk.get_elements( "uses-library", "android:name" )

def grab_file_list(apk) :
	"""
		@param apk : an APK instance
		
		@rtype : the file list inside the AP
	"""
	return apk.zip.namelist()

def grab_certificate(apk, filename) :
	"""
		@param apk : an APK instance
	
		@rtype : a certificate object by giving the name in the apk file
	"""
	try :
		import chilkat
		cert = chilkat.CkCert()
		f = apk.get_file( filename )
		bytedata = chilkat.CkByteData()
		bytedata.append2(f, len(f))
		success = cert.LoadFromBinary(bytedata)
		return success, cert
	except ImportError :
		log.error("The Chilkat module is not installed, you will not have information about the certificate in the generated report")
		return False, []

def grab_certificate_information(apk) :
	"""
		@param apk : an APK instance
		
		@rtype : a certificate object by giving the name in the apk file
	"""
	file_list = grab_file_list(apk)
	p_find_cert = re.compile('^(META-INF\/(.*).RSA)$')
	cert_found = ''
	
	for i in file_list :
		if p_find_cert.match(i):
			cert_found = p_find_cert.match(i).groups()[0]
			log.info("Certificate found : %s", p_find_cert.match(i).groups()[0])

	
	success, cert = grab_certificate(apk, cert_found)
	
	
	if success != True :
		log.error("Can not read the certificate %s from the APK" % cert_found)
		return []

	cert_info_issuer  = ["Issuer:", "C=%s" % cert.issuerC(), "ST=%s" % cert.issuerS(), "L=%s" % cert.issuerL(), "O=%s" % cert.issuerO() , "OU=%s" % cert.issuerOU() , "CN=%s\n\n" % cert.issuerCN() ]
	cert_info_subject  = ["Subject:", "C=%s" % cert.subjectC(), "ST=%s" % cert.subjectS(), "L=%s" % cert.subjectL(), "O=%s" % cert.subjectO() , "OU=%s" % cert.subjectOU() , "CN=%s\n\n" % cert.subjectCN() ]
	
	cert_info = []
	
	cert_info.extend(cert_info_issuer)
	cert_info.extend(cert_info_subject)
	
	cert_info.append("Serial number: %s" % cert.serialNumber())
	cert_info.append("SHA-1 thumbprint: %s" % cert.sha1Thumbprint())
	
	return cert_info
####################################
