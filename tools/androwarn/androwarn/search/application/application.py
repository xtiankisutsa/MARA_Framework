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
import re, logging, urllib2, hashlib
from urllib2 import urlopen, HTTPError

# Androguard imports
from androguard.core.analysis import analysis
from androguard.core.bytecodes.apk import *

# Androwarn modules import
from androwarn.core.core import *
from androwarn.util.util import *

# Constants 
REQUEST_TIMEOUT = 4
ERROR_APP_DESC_NOT_FOUND = 'N/A'

CONNECTION_DISABLED = 0
CONNECTION_ENABLED = 1

# Logguer
log = logging.getLogger('log')


# Some aliases to the original functions
def grab_application_package_name(apk) :
	"""
		@param apk : an APK instance
		
		@rtype : the package name
	"""
	return apk.package

def grab_application_name_description_icon(package_name, no_connection) :
	"""
		@param package_name : package name
	
		@rtype : (name, description, icon) string tuple
	"""
	if no_connection == CONNECTION_DISABLED :
		return ERROR_APP_DESC_NOT_FOUND, ERROR_APP_DESC_NOT_FOUND, ERROR_APP_DESC_NOT_FOUND		
	try :
		# Content in English
		url = "http://play.google.com/store/apps/details?id=%s&hl=en" % str(package_name)
		
		req = urllib2.Request(url)
		response = urllib2.urlopen(req, timeout=REQUEST_TIMEOUT)
		the_page = response.read()
		
		p_name = re.compile(ur'''<h1 class="doc-banner-title">(.*)</h1>''')
		p_desc = re.compile(ur'''(?:\<div id=\"doc-original-text\" \>)(.*)(?:\<\/div\>\<\/div\>\<div class\=\"doc-description-overflow\"\>)''')
		p_icon = re.compile(ur'''(?:\<div class\=\"doc-banner-icon\"\>)(.*)(?:\<\/div\>\<\/td\><td class="doc-details-ratings-price")''')
		
		if p_name.findall(the_page) and p_desc.findall(the_page) and p_icon.findall(the_page) :
			name = strip_HTML_tags(p_name.findall(the_page)[0].decode("utf-8"))
			desc = strip_HTML_tags(p_desc.findall(the_page)[0].decode("utf-8"))
			icon_link = p_icon.findall(the_page)[0]

			return (name, desc, icon_link)

		else :
			log.warn("'%s' application's description and icon could not be found in the page" % str(package_name))
			return ERROR_APP_DESC_NOT_FOUND, ERROR_APP_DESC_NOT_FOUND, ERROR_APP_DESC_NOT_FOUND
	
	except HTTPError :
		log.warn("'%s' application name does not exist on Google Play" % str(package_name))
		return ERROR_APP_DESC_NOT_FOUND, ERROR_APP_DESC_NOT_FOUND, ERROR_APP_DESC_NOT_FOUND

def grab_androidversion_code(apk) :
	"""
		@param apk : an APK instance
		
		@rtype : the android version code
	"""
	return apk.androidversion["Code"]

def grab_androidversion_name(apk) :
	"""
		@param apk : an APK instance
		
		@rtype : the android version name 
	"""
	return apk.androidversion["Name"]
