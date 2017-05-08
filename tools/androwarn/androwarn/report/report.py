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

# Jinja2 module import
try :
	from jinja2 import Environment, PackageLoader, FileSystemLoader, Template
except ImportError :
	sys.exit("[!] The Jinja2 module is not installed, please install it and try again")

# Androwarn modules import
from androwarn.search.search import *
from androwarn.util.util import *

# Logguer
log = logging.getLogger('log')

# Constants 
HTML_TEMPLATE_FILE = './template/template.html'
OUTPUT_DIR = './Report/'

# Constants
REPORT_TXT = 'txt'
REPORT_HTML = 'html'
REPORT_TYPE = [REPORT_TXT, REPORT_HTML]

VERBOSE_ESSENTIAL = '1'
VERBOSE_ADVANCED = '2'
VERBOSE_EXPERT = '3'
VERBOSE_LEVEL = [VERBOSE_ESSENTIAL, VERBOSE_ADVANCED, VERBOSE_EXPERT]

def filter_analysis_results(data, verbosity) :
	
	# Analysis data levels (must match with the analysis module)
	data_level  = {
					# Application
					 'application_name'						: 1 ,
					 'application_version'					: 1 ,
					 'package_name'							: 1 ,
					 'description'							: 1 ,
					
					
					# Malicious Behaviours Detection
					# -- Telephony identifiers leakage				
					 'telephony_identifiers_leakage'		: 1 ,
					
					# -- Device settings harvesting				
					 'device_settings_harvesting'			: 1 ,
					
					# -- Physical location lookup
					 'location_lookup'						: 1 ,

					# -- Connection interfaces information exfiltration
					 'connection_interfaces_exfiltration'	: 1 ,

					# -- Telephony services abuse
					 'telephony_services_abuse'				: 1 ,
					
					# -- Audio/Video eavesdropping
					 'audio_video_eavesdropping'			: 1 ,
					
					# -- Suspicious connection establishment
					 'suspicious_connection_establishment'	: 1 ,

					# -- PIM dataleakage
					 'PIM_data_leakage'						: 1 ,
					
					# -- Native code execution
					 'code_execution'						: 1 ,
					
					# APK 
					 'file_name'							: 1 ,
					 'fingerprint'							: 1 ,
					 'file_list'							: 2 ,
					 'certificate_information'				: 2 ,
					
					
					# Manifest
					 'main_activity'						: 3 ,
					 'activities'							: 3 ,
					 'services'								: 3 ,
					 'receivers'							: 3 ,
					 'providers'							: 3 ,
					 'permissions'							: 1 ,
					 'features'								: 2 ,
					 'libraries'							: 2 ,
					
					
					# APIs
					 'classes_list'							: 3 ,
					 'internal_classes_list'				: 3 ,
					 'external_classes_list'				: 3 ,
					 'internal_packages_list'				: 3 ,
					 'external_packages_list'				: 3 ,
					 'intents_sent'							: 3 
	}

	if data :
		purge_category = []
		
		for category_index, item in enumerate(data) :
			for category, element_tuple in item.iteritems() :
				purge_tuple = []
				
				for tuple_index, tuple in enumerate(element_tuple) :
					name, content = tuple
					
					# if the defined level for an item is above the user's chosen verbosity, remove it
					if (name in data_level) and (int(data_level[name]) > int(verbosity)) :
						purge_tuple.append(tuple_index)
					elif not(name in data_level) :
						log.error("'%s' item has no defined level of verbosity", name)
				
				clean_list(element_tuple,purge_tuple)

			# if there's no item for a category, remove the entire category
			if not(element_tuple) :
				purge_category.append(category_index)
		
		clean_list(data,purge_category)
					
				
	return data

	
def generate_report_txt(data,verbosity, report, output_file) :
	"""
		@param data : analysis result list
		@param verbosity : desired verbosity
		@param report : report type
		@param output_file : output file name
	"""
	output_file = "%s%s.txt" % (OUTPUT_DIR, output_file)
	
	with open(output_file, 'w') as f_out :
		dump_analysis_results(data, f_out)
	f_out.close()
	
	print("[+] Analysis successfully completed and TXT file report available '%s'" % output_file)

def generate_report_html(data, verbosity, report, output_file) :
	"""
		@param data : analysis result list
		@param verbosity : desired verbosity
		@param report : report type
		@param output_file : output file name
	"""
	env = Environment( loader = FileSystemLoader(OUTPUT_DIR), trim_blocks=False, newline_sequence='\n')
	template = env.get_template(HTML_TEMPLATE_FILE)
	
	# In this case we are forced to dump the html into the Report folder as it contains css/img/ico
	output_file = "%s%s.html" % (OUTPUT_DIR, output_file.split('/')[-1])
	
	template.stream(data=data).dump(output_file, encoding='utf-8')
	
	print("[+] Analysis successfully completed and HTML file report available '%s'" % output_file)

def generate_report(package_name, data, verbosity, report) :
	"""
		@param data : analysis result list
		@param verbosity : desired verbosity
		@param report : report type
	"""	
	output_file = package_name
	
	filter_analysis_results(data,verbosity)
	
	if cmp(report, REPORT_TXT) == 0 :
		generate_report_txt(data,verbosity, report, output_file)
	
	if cmp(report, REPORT_HTML) == 0 :
		generate_report_html(data,verbosity, report, output_file)
			

	
