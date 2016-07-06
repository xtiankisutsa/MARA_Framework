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
from androwarn.constants.api_constants import *
from androwarn.util.util import *

# Logguer
log = logging.getLogger('log')

# -- Voice Record -- #
def detect_MediaRecorder_Voice_record(x) :
	"""
		@param x : a VMAnalysis instance
		
		@rtype : a list of formatted strings
	"""	
	formatted_str = []
	
	structural_analysis_results = x.tainted_packages.search_methods("Landroid/media/MediaRecorder","setAudioSource", ".")	
	
	for result in xrange(len(structural_analysis_results)) :
		registers = data_flow_analysis(structural_analysis_results, result, x)
		
		if len(registers) > 0 :
			audio_source_int 	= int(get_register_value(1, registers)) # 1 is the index of the PARAMETER called in the method
			audio_source_name 	= get_constants_name_from_value(MediaRecorder_AudioSource, audio_source_int)
			
			local_formatted_str = "This application records audio from the '%s' source " % audio_source_name
			if not(local_formatted_str in formatted_str) :
				formatted_str.append(local_formatted_str)
		
	return formatted_str

# -- Video Record -- #
def detect_MediaRecorder_Video_capture(x) :
	"""
		@param x : a VMAnalysis instance
		
		@rtype : a list of formatted strings
	"""	
	formatted_str = []
	
	structural_analysis_results = x.tainted_packages.search_methods("Landroid/media/MediaRecorder","setVideoSource", ".")	
	
	for result in xrange(len(structural_analysis_results)) :
		registers = data_flow_analysis(structural_analysis_results, result, x)	
		
		if len(registers) > 0 :
			video_source_int 	= int(get_register_value(1, registers)) # 1 is the index of the PARAMETER called in the method
			video_source_name 	= get_constants_name_from_value(MediaRecorder_VideoSource, video_source_int)
			
			local_formatted_str = "This application captures video from the '%s' source" % video_source_name
			if not(local_formatted_str in formatted_str) :
				formatted_str.append(local_formatted_str)
	

	return formatted_str

def gather_audio_video_eavesdropping(x) :
	"""
		@param x : a VMAnalysis instance
	
		@rtype : a list strings for the concerned category, for exemple [ 'This application makes phone calls', "This application sends an SMS message 'Premium SMS' to the '12345' phone number" ]
	"""
	result = []
	
	result.extend ( detect_MediaRecorder_Voice_record(x) )
	result.extend ( detect_MediaRecorder_Video_capture(x) )
	
	return result
