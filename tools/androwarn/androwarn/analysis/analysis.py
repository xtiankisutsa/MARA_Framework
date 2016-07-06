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
import sys, logging

# Androguard import
from androguard.core.bytecode import *
from androguard.core.bytecodes.dvm import *
from androguard.core.bytecodes.apk import *

# Androwarn modules import
from androwarn.core.core import *
from androwarn.search.search import *
from androwarn.util.util import *

# Logguer
log = logging.getLogger('log')

def AnalyzeAPK(filename, raw=False, decompiler=None) :
	"""
		Analyze an android application and setup all stuff for a more quickly analysis !

		@param filename : the filename of the android application or a buffer which represents the application
		@param raw : True is you would like to use a buffer
		@param decompiler : ded, dex2jad, dad or None for smali dump only
		
		@rtype : return the APK, DalvikVMFormat, and VMAnalysis objects
	"""
	a = APK(filename, raw)

	d, dx = AnalyzeDex( a.get_dex(), raw=True )
	
	return a, d, dx

def AnalyzeDex(filename, raw=False) :
	"""
		Analyze an android dex file and setup all stuff for a more quickly analysis !

		@param filename : the filename of the android dex file or a buffer which represents the dex file
		@param raw : True is you would like to use a buffer

		@rtype : return the DalvikVMFormat, and VMAnalysis objects
	"""
	# DalvikVMFormat
	d = None
	if raw == False :
		d = DalvikVMFormat( open(filename, "rb").read() )
	else :
		d = DalvikVMFormat( filename )

	# EXPORT VM to python namespace
	#ExportVMToPython( d )

	# VMAnalysis
	dx = VMAnalysis( d )
	#dx = uVMAnalysis( d )

	d.set_vmanalysis( dx )
	
	return d, dx

# Consolidate all data
def perform_analysis(apk_file, a, d, x, no_connection) :
	"""
		@param apk_file 		: apk file path
		@param a 				: an APK instance, DalvikVMFormat, and VMAnalysis objects
		@param d 				: a DalvikVMFormat instance
		@param x 				: a VMAnalysis instance
		@param no_connection	: boolean value, enable/disable online lookups
	
		@rtype : a list of dictionaries of strings lists [ { "application_information": [ ("application_name", ["com.test"]), ("application_version", ["1.0"]) ] }, { ... }]
	"""
	# application general information 
	app_package_name = grab_application_package_name(a)
	app_name, app_desc, app_icon = grab_application_name_description_icon(app_package_name, no_connection)
	app_description = [app_icon, app_desc]
	
	# data gathering
	data = []
	
	data.append(
				{ 'application_information' :
					[
						( 'application_name', 						[app_name] ),
						( 'application_version', 					[grab_androidversion_name(a)] ),
						( 'package_name', 							[app_package_name] ),
						( 'description', 					 		 app_description )
					]
				}
	)
	
	data.append(
				{ 'analysis_results' :
					[
						( 'telephony_identifiers_leakage', 			 gather_telephony_identifiers_leakage(x) ),
						( 'device_settings_harvesting', 			 gather_device_settings_harvesting(x) ),
						( 'location_lookup', 						 gather_location_lookup(x) ),
						( 'connection_interfaces_exfiltration', 	 gather_connection_interfaces_exfiltration(x) ),
						( 'telephony_services_abuse', 				 gather_telephony_services_abuse(a,x) ),										
						( 'audio_video_eavesdropping', 				 gather_audio_video_eavesdropping(x) ),
						( 'suspicious_connection_establishment',	 gather_suspicious_connection_establishment(x) ),
						( 'PIM_data_leakage', 						 gather_PIM_data_leakage(x) ),
						( 'code_execution', 						 gather_code_execution(x) ),
					],
				}
	)
	
	data.append(
				{ 'apk_file' :
					[
						( 'file_name', 								[grab_filename(a)] ),
						( 'fingerprint', 							 grab_apk_file_hashes(apk_file) ),
						( 'file_list', 								 grab_file_list(a) ),
						( 'certificate_information', 				 grab_certificate_information(a) )
					]
				}
	)	
	
	data.append(
				{ 'androidmanifest.xml' :
					[
						( 'main_activity', 							[grab_main_activity(a)] ),
						( 'activities', 							 grab_activities(a) ),
						( 'receivers', 								 grab_services(a) ),
						( 'providers', 								 grab_providers(a) ),
						( 'permissions', 							 grab_permissions(a) ),
						( 'features', 								 grab_features(a) ),
						( 'libraries', 							 	 grab_libraries(a) )
					]
				}
	)

	data.append(
				{ 'apis_used' :
					[
						( 'classes_list', 							 grab_classes_list(x) ),
						( 'internal_classes_list', 					 grab_internal_classes_list(x) ),
						( 'external_classes_list', 					 grab_external_classes_list(x) ),
						( 'internal_packages_list', 				 grab_internal_packages_list(x) ),
						( 'external_packages_list', 				 grab_external_packages_list(x) ),
						( 'intents_sent',							 grab_intents_sent(x) )
					]
				}
	)	
	
	return data
