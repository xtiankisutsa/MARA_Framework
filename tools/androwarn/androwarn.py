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
import sys, re, logging

# OptionParser imports
from optparse import OptionParser

# Androguard imports
PATH_INSTALL = "./androguard/"
sys.path.append(PATH_INSTALL)

# Androwarn modules import
PATH_INSTALL = "./"
sys.path.append(PATH_INSTALL)
from androwarn.core.core import *
from androwarn.search.search import *
from androwarn.util.util import *
from androwarn.report.report import *
from androwarn.analysis.analysis import *

# Logger definition
log = logging.getLogger('log')
log.setLevel(logging.ERROR)
formatter = logging.Formatter('[%(levelname)s] %(message)s')
handler = logging.StreamHandler()
handler.setFormatter(formatter)
log.addHandler(handler)

# Options definition
option_0 = { 'name' : ('-i', '--input'), 'help' : 'APK file to analyze', 'nargs' : 1 }
option_1 = { 'name' : ('-v', '--verbose'), 'help' : 'Verbosity level { 1-3 } (ESSENTIAL, ADVANCED, EXPERT)', 'nargs' : 1 }
option_2 = { 'name' : ('-r', '--report'), 'help' : 'Report type { txt, html }', 'nargs' : 1 }
option_3 = { 'name' : ('-d', '--display-report'), 'help' : 'Display analysis results to stdout', 'action' : 'count' }
option_4 = { 'name' : ('-L', '--log-level'), 'help' : 'Log level { DEBUG, INFO, WARN, ERROR, CRITICAL }', 'nargs' : 1 }
option_5 = { 'name' : ('-n', '--no-connection'), 'help' : 'Disable online lookups on Google Play', 'action' : 'count'}

options = [option_0, option_1, option_2, option_3, option_4, option_5]


def main(options, arguments) :

			
	if (options.input != None) :
		
		# Log_Level
		if options.log_level != None :
			try :
				log.setLevel(options.log_level)
			except :
				parser.error("Please specify a valid log level")
		
		# Verbose
		if (options.verbose != None) and (options.verbose in VERBOSE_LEVEL) :
			verbosity = options.verbose
		else :
			parser.error("Please specify a valid verbose level")
		
		# Report Type	
		if (options.report != None) and (options.report in REPORT_TYPE) :
			report_wanted = True
			report = options.report
		elif (options.report == None) and (options.display_report != None) :
			report_wanted = False
		else :
			parser.error("Please specify a valid report type")

		# Online Lookups enabled	
		no_connection = {True : CONNECTION_DISABLED, False : CONNECTION_ENABLED}[options.no_connection != None] 

		# Input	
		APK_FILE = options.input


		a, d, x = AnalyzeAPK(APK_FILE)

		package_name = grab_application_package_name(a)
		
		data = perform_analysis(APK_FILE, a, d, x, no_connection)
		
		if (options.display_report != None) :
			# Brace yourself, a massive dump is coming
			dump_analysis_results(data,sys.stdout) 
		
		if report_wanted :
			generate_report(package_name, data, verbosity, report)

if __name__ == "__main__" :
	parser = OptionParser()
	for option in options :
		param = option['name']
		del option['name']
		parser.add_option(*param, **option)

	options, arguments = parser.parse_args()
	main(options, arguments)
