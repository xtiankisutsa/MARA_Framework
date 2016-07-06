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

def detect_Socket_use(x) :
	"""
		@param x : a VMAnalysis instance
		
		@rtype : a list of formatted strings
	"""
	formatted_str = []
	
	structural_analysis_results = x.tainted_packages.search_methods("Ljava/net/Socket","<init>", ".")
	
	for result in xrange(len(structural_analysis_results)) :
		registers = data_flow_analysis(structural_analysis_results, result, x)

		if len(registers) >= 2 :
			remote_address 	= get_register_value(1, registers) # 1 is the index of the PARAMETER called in the method
			remote_port		= get_register_value(2, registers)
			
			local_formatted_str = "This application opens a Socket and connects it to the remote address '%s' on the '%s' port " % (remote_address, remote_port)
			if not(local_formatted_str in formatted_str) :
				formatted_str.append(local_formatted_str)		
	
	return formatted_str

def gather_suspicious_connection_establishment(x) :	
	"""
		@param x : a VMAnalysis instance
	
		@rtype : a list strings for the concerned category, for exemple [ 'This application makes phone calls', "This application sends an SMS message 'Premium SMS' to the '12345' phone number" ]
	"""
	result = []
	
	result.extend( detect_Socket_use(x) ) 
		
	return result
