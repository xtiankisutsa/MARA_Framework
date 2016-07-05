#!/usr/bin/env python

# Copyright (c) Mohesh Mohan (h4hacks.com).

'''
Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

'''

# Completed standalone multi threaded script for SSL labs API - 18th June 2015, Mohesh Mohan
import re, sys, getopt, argparse
import unirest
from mimetools import Message
from StringIO import StringIO
import json
import csv
import linecache
from urlparse import urlparse
import Queue
import threading
import time
import random
import os

def testBit(int_type, offset):
	mask = 1 << offset
	return(int_type & mask)
	
def parsetodomain(url):
	#dirty fix to match our dirty apps db :P
	if "http" not in url:
		url = "http://" + url
	pdomain = ''
	parsed_uri = urlparse(url)
	pdomain = '{uri.netloc}'.format(uri=parsed_uri)
	return (pdomain)

def isURL(url):
	if "http" not in url:
		url = "http://" + url
	if "*" in url:
		return False
	regex = re.compile(
        r'^(?:http|ftp)s?://' # http:// or https://
        r'(?:(?:[A-Z0-9](?:[A-Z0-9-]{0,61}[A-Z0-9])?\.)+(?:[A-Z]{2,6}\.?|[A-Z0-9-]{2,}\.?)|' #domain...
        r'localhost|' #localhost...
        r'\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})' # ...or ip
        r'(?::\d+)?' # optional port
        r'(?:/?|[/?]\S+)$', re.IGNORECASE)
	return (regex.match(url))

def parseresults(result,mainapp,returncode):
	pdomain = mainapp
	print "\nParsing : " + str(mainapp)
	domain=ip=grade=sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y='not tested'
	try:
		#domain 
		try:
			domain=result['host']
		except Exception:
			domain="error"
			pass		
		#IP
		try:
			ip = result['endpoints'][0]['ipAddress']
		except Exception:
			ip="JSON err"
			pass
		#grade
		try:
			grade = result['endpoints'][0]['grade']
		except Exception:
			grade="JSON err"
			pass	
		#sgrade
		try:
			sgrade = result['endpoints'][0]['gradeTrustIgnored']
		except Exception:
			sgrade="JSON err"
			pass			
		#freak
		try:
			freak= "N"
			if result['endpoints'][0]['details']['freak']== True:
				freak = "Y"
		except Exception,e:
			#print str(e)
			freak="JSON err"
			pass
		
		
		
		#Logjam
		try:
			logjam= "N"
			if result['endpoints'][0]['details']['logjam']== True:
				logjam = "Y"
		except Exception,e:
			#print str(e)
			logjam="JSON err"
			pass
		
		
		
		#PoodleTLS
		try:
			poodlevar = result['endpoints'][0]['details']['poodleTls']
			if poodlevar == 2:
				poodletls ="Y"
			elif poodlevar == 1:
				poodletls = "N"
			else:
				poodletls = "fail"
		except Exception,e:
			#print str(e)
			poodletls="JSON err"
			pass		
		#reneg suport
		try:
			insecr ="N"
			renegvar = int(result['endpoints'][0]['details']['renegSupport'])
			renegp = testBit(renegvar, 0)
			if renegp != 0:
				insecr ="Y"
		except Exception,e:
			#print str(e)
			insecr="JSON err"
			pass		
		#ccs
		try:
			ccsvar = result['endpoints'][0]['details']['openSslCcs']
			if ccsvar == 1:
				ccs ="N"
			elif ccsvar==3:
				ccs = "Y"
			else:
				ccs = "N"
		except Exception,e:
			#print str(e)
			ccs="JSON err"
			pass
		#insecdh
		try:
			insecdh= "N"
			for suite in result['endpoints'][0]['details']['suites']['list']:
				try:
					if "DHE" in suite['name']:
						try:
							if suite['q']==0:
								insecdh = "Y"
								#print "possible insec DH in " + suite['name']
						except Exception,e:
							print "safe DHE :" + suite['name']
				except Exception,e:
					#print str(e)
					pass
		except Exception,e:
			#print str(e)
			insecdh="JSON err"
			pass
		#ssl2
		try:
			ssl2= "N"
			v2SuitesDisabled= "Y"
			for protocol in result['endpoints'][0]['details']['protocols']:
				if "SSL" in protocol['name'] and protocol['version']=="2.0":
					ssl2 = "Y"
					if protocol['v2SuitesDisabled']== True:
						v2SuitesDisabled = "Y"
					else:
						v2SuitesDisabled = "N"
					
					
		except Exception,e:
			#print str(e)
			ssl2="JSON err"
			pass
			
			
					
			
		#tls12
		try:
			tls12= "Y"
			for protocol in result['endpoints'][0]['details']['protocols']:
				if "TLS" in protocol['name'] and protocol['version']=="1.2":
					tls12 = "N"
		except Exception,e:
			#print str(e)
			tls12="JSON err"
			pass
		#ssl3
		try:
			ssl3= "N"
			for protocol in result['endpoints'][0]['details']['protocols']:
				if "SSL" in protocol['name'] and protocol['version']=="3.0":
					ssl3 = "Y"
		except Exception,e:
			#print str(e)
			ssl3="JSON err"
			pass
		#rc4
		try:
			rc4var = result['endpoints'][0]['details']['supportsRc4']
			if rc4var:
				rc4 ="Y"
			else:
				rc4 = "N"
		except Exception,e:
			#print str(e)
			rc4="JSON err"
			pass
			
			
			#rc4 Only
		try:
			rc4Onlyvar = result['endpoints'][0]['details']['rc4Only']
			if rc4Onlyvar:
				rc4Only ="Y"
			else:
				rc4Only = "N"
		except Exception,e:
			#print str(e)
			rc4Only="JSON err"
			pass
			
			
		#weaks
		try:
			weaks="N"
			if "SHA1" in result['endpoints'][0]['details']['cert']['sigAlg']:
				weaks ="Y"
		except Exception,e:
			#print str(e)
			weaks="Err"
			pass
		#poodlessl
		try:
			poodlessl="N"
			if result['endpoints'][0]['details']['poodle']== True:
				poodlessl="Y"
		except Exception,e:
			#print str(e)
			poodlessl="Err"
			pass		
		#certchain
		try:
			certchain="N"
			certmsg = int(result['endpoints'][0]['details']['cert']['issues'])
			chainp = testBit(certmsg, 0)
			if chainp != 0 or int(result['endpoints'][0]['details']['chain']['issues']) !=0 :
				certchain ="Y"
		except Exception,e:
			#print str(e)
			certchain="Err"
			pass
		#chainincomp
		try:
			chaininc="N"
			certmsg1 = int(result['endpoints'][0]['details']['chain']['issues'])
			chainp1 = testBit(certmsg1, 1)
			if chainp1 != 0 :
				chaininc ="Y"
		except Exception,e:
			#print str(e)
			chaininc="Err"
			pass
		#wrongd
		try:
			wrongd="N"
			certmsg = int(result['endpoints'][0]['details']['cert']['issues'])
			chainp = testBit(certmsg, 3)
			if chainp != 0:
				wrongd ="Y"
		except Exception,e:
			#print str(e)
			wrongd="Err"
			pass
		#selfcert
		try:
			selfcert="N"
			certmsg = int(result['endpoints'][0]['details']['cert']['issues'])
			chainp = testBit(certmsg, 6)
			if chainp != 0:
				selfcert ="Y"
		except Exception,e:
			#print str(e)
			selfcert="Err"
			pass		
		#certexp
		try:
			certexp="N"
			certmsg = int(result['endpoints'][0]['details']['cert']['issues'])
			ntbef = testBit(certmsg, 1)
			ntaf = testBit(certmsg, 2)
			if ntbef != 0 or ntaf != 0:
				certexp ="Y"
		except Exception,e:
			#print str(e)
			certexp="Err"
			pass	
		#crime
		try:
			crime="N"
			if result['endpoints'][0]['details']['compressionMethods']!= 0 and result['endpoints'][0]['details']['supportsNpn'] == False:
				crime ="Y"
		except Exception,e:
			#print str(e)
			crime="Err"
			pass
		#eycert
		try:
			eycert="N"
			if "EY Issuing" in result['endpoints'][0]['details']['cert']['issuerLabel']:
				eycert ="Y"
		except Exception,e:
			#print str(e)
			eycert="Err"
			pass
		#secreneg
		try:
			secreneg="N"
			certmsg = int(result['endpoints'][0]['details']['renegSupport'])
			secre = testBit(certmsg, 1)
			if secre != 0:
				secreneg ="Y"
		except Exception,e:
			#print str(e)
			secreneg="Err"
			pass
		#fwsec inverted logic :P
		try:
			fwsec="Y"
			fwsecvar = result['endpoints'][0]['details']['forwardSecrecy']
			fws = testBit(fwsecvar, 2)
			if fws != 0:
				fwsec ="N"
		except Exception,e:
			#print str(e)
			fwsec="JSON err"
			pass
		#weakkey
		try:
			weakkey="N"
			if (("SA" in result['endpoints'][0]['details']['key']['alg']) and int(result['endpoints'][0]['details']['key']['size'])<2048) or (("EC" in result['endpoints'][0]['details']['key']['alg']) and int(result['endpoints'][0]['details']['key']['size'])<256) :
				weakkey ="Y"
		except Exception,e:
			weakkey="N"
			pass
		#tls10
		try:
			tls10= "N"
			for protocol in result['endpoints'][0]['details']['protocols']:
				if "TLS" in protocol['name'] and protocol['version']=="1.0":
					tls10 = "Y"
		except Exception,e:
			#print str(e)
			tls10="JSON err"
			pass
		#tls10
		try:
			tls11= "N"
			for protocol in result['endpoints'][0]['details']['protocols']:
				if "TLS" in protocol['name'] and protocol['version']=="1.1":
					tls11 = "Y"
		except Exception,e:
			#print str(e)
			tls11="JSON err"
			pass
		#tls10
		try:
			tls12y= "N"
			for protocol in result['endpoints'][0]['details']['protocols']:
				if "TLS" in protocol['name'] and protocol['version']=="1.2":
					tls12y = "Y"
		except Exception,e:
			#print str(e)
			tls12y="JSON err"
			pass
				# write deal details to CSV
		#thumb print
		try:
			thumbp = result['endpoints'][0]['details']['cert']['sha1Hash']
		except Exception,e:
			#print str(e)
			thumbp="JSON err"
			pass	
			
		#common names
		try:
			commonnames= ""
			for common in result['endpoints'][0]['details']['cert']['commonNames']:
				commonnames = " ".join((commonnames, common))
		except Exception,e:
			#print str(e)
			commonnames="JSON err"
			pass		
			
		#alternate names
		try:
			altnames= ""
			for alt in result['endpoints'][0]['details']['cert']['altNames']:
				altnames = " ".join((altnames, alt))
		except Exception,e:
			#print str(e)
			altnames="JSON err"
			pass			
		
		#drown
		try:
			drown="N"
			if result['endpoints'][0]['details']['drownErrors'] == False and result['endpoints'][0]['details']['drownVulnerable'] == True :
				drown ="Y"
			elif result['endpoints'][0]['details']['drownErrors'] == True :
				drown = "Assessment error"
		except Exception,e:
			print str(e)
			drown="Err"
			pass
		
		
		# For error values
		#No SSL
		try:
			if result['endpoints'][0]['statusMessage'] =="No secure protocols supported":
				grade = "No SSL/TLS"
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='NA'
		except Exception,e:
			pass
		#No DNS
		try:
			if result['statusMessage'] =="Unable to resolve domain name":
				grade = "No DNS"
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='NA'
		except Exception,e:
			pass
		#Unknown errors from server stupid stuff. not optimal need to work on this
		try:
			if "Unable" in result['endpoints'][0]['statusMessage']:
				grade = result['endpoints'][0]['statusMessage']
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='Error'
		except Exception,e:
			pass
		try:
			if "Failed" in result['endpoints'][0]['statusMessage']:
				grade = result['endpoints'][0]['statusMessage']
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='Error'
		except Exception,e:
			pass			
		try:
			if "RFC 1918" in result['endpoints'][0]['statusMessage']:
				grade = result['endpoints'][0]['statusMessage']
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=ertchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='Error'
		except Exception,e:
			pass
			
		try:
			if "Unexpected" in result['endpoints'][0]['statusMessage']:
				grade = result['endpoints'][0]['statusMessage']
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='Error'
		except Exception,e:
			pass	
		try:
			if "Internal error" in result['endpoints'][0]['statusMessage']:
				grade = result['endpoints'][0]['statusMessage']
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='Error'
		except Exception,e:
			pass
		try:
			if "Internal Error" in result['endpoints'][0]['statusMessage']:
				grade = result['endpoints'][0]['statusMessage']
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='Error'
		except Exception,e:
			pass
			
		try:
			if result['status'] =="ERROR" and result['statusMessage'] !="Unable to resolve domain name":
				grade = "Error from server, need manual tests"
				sgrade=freak=logjam=poodletls=insecr=ccs=insecdh=ssl2=v2SuitesDisabled=poodlessl=weaks=tls12=ssl3=rc4=rc4Only=certchain=chaininc=crime=wrongd=certexp=fwsec=weakkey=eycert=selfcert=secreneg=tls10=tls11=tls12y=thumbp=commonnames=altnames=drown='Error'
		except Exception,e:
			pass		
		
		row = ""
		row = pdomain,domain,ip,'','','','','','','','','',returncode,grade,sgrade,'','','','',drown,freak,logjam,poodletls,insecr,ccs,insecdh,ssl2,v2SuitesDisabled,poodlessl,wrongd,certexp,eycert,selfcert,tls12,ssl3,rc4,rc4Only,certchain,chaininc,crime,fwsec,weakkey,weaks,secreneg,tls10,tls11,tls12y,'','','','','',thumbp,commonnames,altnames
		print "Parsed: " + str(mainapp)
		return(row)
	
	except Exception,e:
		row = pdomain,domain,'Failed','','','','','','','','','',returncode,grade,sgrade,'','','','',drown,freak,logjam,poodletls,insecr,ccs,insecdh,ssl2,v2SuitesDisabled,poodlessl,wrongd,certexp,eycert,selfcert,tls12,ssl3,rc4,rc4Only,certchain,chaininc,crime,fwsec,weakkey,weaks,secreneg,tls10,tls11,tls12y,'','','','','','','',''
		return(row)
	
newjob = False
mainapps = []
jobtrack = {}
parser = argparse.ArgumentParser(description='SSL labs mass test tool', add_help=True, epilog='SSL labs mass test tool. Made by Mohesh Mohan for Global info sec, security audit team (PCC). Ernst & Young, 2015')
parser.add_argument('-i','--input', help='The input file with list of URLs', required=True)
parser.add_argument('-o','--output', help='Output csv file', required=True)
parser.add_argument('-n','--new', help='Start new assesment, dont use cache', required=False, action='store_true')
argsdict = vars(parser.parse_args())

if not os.path.exists(os.getcwd() + "\\results"):
    os.makedirs(os.getcwd()+ "\\results")

newjob = argsdict['new']
in_file = argsdict['input']

line_no = 1
diter = ""
read_line = linecache.getline(in_file, line_no).rstrip()

while read_line is not "":
	line_no = line_no + 1
	mainapps.append(read_line)
	diter = parsetodomain(read_line)
	if isURL(read_line):
		jobtrack[diter] = "Not Tested"
	else:
		jobtrack[diter] = "Invalid"
		print read_line + " is invalid"
	read_line = linecache.getline(in_file, line_no).rstrip()
	
total_lines = line_no - 1

print "There are %d Urls read from the File" % (total_lines)

#print mainapps
print "\n No of URLs is identified is " + str(len(mainapps))
#print "\n"
#print jobtrack
print "\n No of domains is " + str(len(jobtrack))

#raw_input("Press Enter to continue...")

apipath = "https://api.ssllabs.com/api/v2/"
clientheaders = { "User-Agent": "pyssltest 1.3"}

infocommand = apipath + "info"
analyzecommand = apipath + "analyze"
getdatacommand = apipath + "getEndpointData"

if newjob == True:
	pstart = {"publish" : "off", "ignoreMismatch" : "on", "all" : "done", "host" : "", "startNew" : "on"}
else:
	pstart = {"publish" : "off", "ignoreMismatch" : "on", "all" : "done", "host" : "", "fromCache" : "on"}
prepeat = {"publish" : "off", "ignoreMismatch" : "on", "all" : "done", "host" : ""}
pinfo = {}

#response = unirest.get(infocommand, headers=clientheaders, params=pinfo)
#headers1 = Message(StringIO(response.headers))
#print response.code # The HTTP status code
#print response.headers
#print headers1['X-Max-Assessments'] # The HTTP headers
#print str(response.body) # The parsed response
#print "raw follows"
#print response.raw_body # The unparsed response

def status():
	ready = 0
	inva = 0
	errc = 0
	pend = 0
	print '\n' * 100
	for key in jobtrack:
			if jobtrack[key] =="Not Tested":
				pend = pend + 1
			elif jobtrack[key] =="Invalid":
				inva = inva + 1
			elif jobtrack[key] =="ERROR":
				errc = errc + 1
			elif jobtrack[key] =="READY":
				ready = ready + 1
	print "\n There are " + str(pend) + " pending"
	print "\n There are " + str(inva) + " Invalid"
	print "\n There are " + str(errc) + " errors"
	print "\n There are " + str(ready) + " ready"
	print "\n There are " + str(threading.activeCount()) + " Threads"
	
def runscan(q):
	while not q.empty():
		mydata = threading.local()
		mydata.scanning = True
		mydata.dom = q.get() # get the item from the queue
		mydata.pstart = pstart
		mydata.prepeat = prepeat
		print "Now Processing " + str(mydata.dom)
		#print "\n Active threads :" + str(threading.activeCount())
		while (mydata.scanning):
			try:
				status()
				
				# if for some unknown reason a thread just don't die, lets kill it
				if jobtrack[mydata.dom] != "Scanning" and jobtrack[mydata.dom] != "Not Tested":
					q.task_done()
					mydata.scanning = False
					
			# Check if scan is initiated for this one 
				if jobtrack[mydata.dom] =="Not Tested":
					mydata.pstart['host'] = mydata.dom
					mydata.response = unirest.get(analyzecommand, headers=clientheaders, params=mydata.pstart)
					jobtrack[mydata.dom] = "Scanning"
				else:
					mydata.prepeat['host'] = mydata.dom
					mydata.response = unirest.get(analyzecommand, headers=clientheaders, params=mydata.prepeat)
					# did we get any valid response?
					if 'status' in mydata.response.body:
						if mydata.response.body['status'] == "READY" or mydata.response.body['status'] =="ERROR" :
							mydata.host = mydata.response.body['host']
							#print "Response is for " + mydata.host
							#print "Dom is " + mydata.dom
							if mydata.host == mydata.dom:
								jobtrack[mydata.host] = mydata.response.body['status']
								mydata.fo = open("results/"+mydata.host+".txt", "wb")
								#mydata.fo.write(mydata.response.raw_body);
								json.dump(mydata.response.body,mydata.fo)
								# Close opend file
								mydata.fo.close()
								q.task_done()
								mydata.scanning = False
								print mydata.host + " is " + mydata.response.body['status']
				mydata.headers1 = Message(StringIO(mydata.response.headers))
				if mydata.response.code == 429:
					print "\nThread: " + str(mydata.dom) +" to sleep 10 secs due to 429 from server"
					time.sleep(10)
				elif mydata.response.code == 503 or mydata.response.code == 529:
					print "\n server overload, Response code is :" + str(mydata.response.code)
					randtime = random.randrange(100, 500)
					print "\n Sleeping for :" + str(randtime)
					time.sleep(randtime)
				time.sleep(3) # delays for 5 seconds
				#print headers1['X-Max-Assessments'] 
			except Exception,e:
				print str(e)
				try:
					if 'errors' in mydata.response.body:
						jobtrack[mydata.dom] = mydata.response.body['status']
						mydata.fo = open("results/"+mydata.dom+".txt", "wb")
						json.dump(mydata.response.body,mydata.fo)
						mydata.fo.close()
						q.task_done()
						mydata.scanning = False
				except Exception,e:
					print str(e)
					pass
				pass


				

q = Queue.LifoQueue()
#put items to queue
for key in jobtrack:
	if jobtrack[key] != "Invalid":
		q.put(str(key))	
	else:
		print str(key) + " is not added to queue as its invalid"

for i in range(100):
	t1 = threading.Thread(target=runscan,args=(q,)) 
	t1.daemon = True
	t1.start() # start the thread
					
q.join() 

print "\nFinally"
print jobtrack
csvw = csv.writer(open(argsdict['output'], 'wb'))
csvw.writerow(['Input_URL', 'Domain','IP','Common Name','Source','Date Added','Portfolio','sub portfolio','ELT', 'POC','IT Contact','Status','returncode', 'Grade','Secondary grade','Expected Remediation Date','Grade After Remediation','Actual Remediation Date','Actual Grade after Remediation','Drown (Experimental)','Freak','Logjam','Poodle_TLS','Insecure renegotiation','OpenSSL ccs','Insecure DH','SSL v2','SSLv2 SuitesDisabled','Poodle_SSL','wrong domain',  'cert expired','Ey issued cert','self signed cert','No TLS1.2?', 'SSL v3', 'RC4','rc4Only', 'cert chain issue','Cert chain incomplete', 'CRIME',  'forward secrecy not supported?', 'weak private key?','weak signature','secure renegotiation', 'TLS 1.0','TLS 1.1','TLS 1.2','Recommendation to raise score to A', 'Date Last scanned(Auto)','Date Manually validated','Comments', 'Audit teams Comments(New grade as on *)','Thumbprint','common names', 'alternate names' ])

for app in mainapps:
	try:
		curdom = parsetodomain(app)
		resfile = open("results/"+curdom+".txt", "r")
		jsonresults = json.load(resfile)
		resfile.close()
		row = parseresults(jsonresults,app,jobtrack[curdom])
		csvw.writerow(row)			
	except Exception,e:
		print str(e)
		csvw.writerow([app,curdom ,str(e),jobtrack[curdom], 'Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error', 'Error','Error','Error','Error', 'Error', 'Error', 'Error', 'Error', 'Error', 'Error','Error','Error', 'Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error','Error' ])
		pass
