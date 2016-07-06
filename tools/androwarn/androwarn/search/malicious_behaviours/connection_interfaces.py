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
import logging

# Androguard imports
from androguard.core.analysis import analysis
from androguard.core.bytecodes.apk import *

# Androwarn modules import
from androwarn.core.core import *
from androwarn.util.util import *

# Logguer
log = logging.getLogger('log')

def detect_Connectivity_Manager_leakages(x):
	"""
		@param x : a VMAnalysis instance
	
		@rtype : a list strings for exemple [ 'This application makes phone calls', "This application sends an SMS message 'Premium SMS' to the '12345' phone number" ]
	"""
	
	class_listing = [
			("getActiveNetworkInfo()",		"This application reads details about the currently active data network"),
			("isActiveNetworkMetered()", 	"This application tries to find out if the currently active data network is metered")
	]
	
	class_name = 'Landroid/net/ConnectivityManager'
	
	return bulk_structural_analysis(class_name, class_listing, x)
 
def detect_WiFi_Credentials_lookup(x) :
	"""
		@param x : a VMAnalysis instance
		
		@rtype : a list of formatted strings
	"""
	# This functions aims some HTC android devices 
	# Several HTC devices suffered from a bug allowing to dump wpa_supplicant.conf file containing clear text credentials
	# http://www.kb.cert.org/vuls/id/763355
	
	formatted_str = []
	
	structural_analysis_results = x.tainted_packages.search_methods("Landroid/net/wifi/WifiConfiguration","toString", ".")
	for result in xrange(len(structural_analysis_results)) :
		registers = data_flow_analysis(structural_analysis_results, result, x)	
		
		local_formatted_str = "This application reads the WiFi credentials" 
		
		# we want only one occurence
		if not(local_formatted_str in formatted_str) :
			formatted_str.append(local_formatted_str)

		
	return formatted_str	

def gather_connection_interfaces_exfiltration(x) :
	"""
		@param x : a VMAnalysis instance
	
		@rtype : a list strings for the concerned category, for exemple [ 'This application makes phone calls', "This application sends an SMS message 'Premium SMS' to the '12345' phone number" ]
	"""
	result = []
	
	result.extend( detect_WiFi_Credentials_lookup(x) )
	result.extend( detect_Connectivity_Manager_leakages(x) )
	
	return result
