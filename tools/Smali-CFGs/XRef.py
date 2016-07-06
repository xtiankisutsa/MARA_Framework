import sys
import os
import re
from optparse import OptionParser
import pydot

## Smali Metasyntactic representation:
#	.class visibility Lfoo/bar/baz;
#	.method visibility foo <access-spec>(bar;baz)qux
#	invoke-direct/virtual {pn}, Lfoo/bar/baz;->qux(Lquux/corge/grault;)Lgarply/waldo/fred;

## Globals about smali types
#	[x   = one dimension array of x type
#	[[x	 = two dimension array of x type
#	Lfoo; = foo object
#	Z/B/S/C/I/J/F/D = single types

## Globals about smali types symbols distribution
#   '[' ends with any type symbol
#	'L' ends with ;
#	'other' ends with any other type symbol or delimiter ';' '['

class Smali_Function(object):
	TYPES_STRINGS = {
		'V' : 'void',
		'Z' : 'boolean',
		'B' : 'byte',
		'S' : 'short',
		'C' : 'char',
		'I' : 'int',
		'J' : 'long',
		'F' : 'float',
		'D' : 'double'
	}

	# Constructor
	## 
	def __init__(self):
		self.class_owner  = None
		self.method_name  = None
		self.return_type  = None
		self.parameters   = []

	# Method parameters types
	## looking for quux/corge/grault and so on.
	def _extractCallParameters(self, line):
		useful_parts  = line.split(' ')[-1][1:]
		params_string = useful_parts.split('(')[1].split(')')[0]
		temp_params=[]
		array = False
		# Please, review initial global types notes.
		while len(params_string)>0:
			i=0
			if i<len(params_string):
				# object type
				if params_string[i]=='L':
					while ((params_string[i]!=';') and (i<len(params_string))):
						i+=1
					if array:
						temp_params.append(params_string[1:i]+"[]")
						array=False
					else:
						temp_params.append(params_string[1:i])
					params_string=params_string[i+1:]
				# array type
				elif (params_string[i]=='['):
					array = True
					while (params_string[i]=='['):
						i+=1
					params_string=params_string[i:]
				# single type
				else:
					value = self.TYPES_STRINGS[params_string[i]]
					if array:
						temp_params.append(value+"[]")
						array=False
					else:
						temp_params.append(value)
					params_string = params_string[i+1:]
		self.parameters = temp_params

	# Method return type
	## looking for garply/waldo/fred
	def _extractReturnType(self, line):
		useful_parts  = line.split(' ')[-1][1:]
		retval = line.split(')')[1]
		## TODO: and... what about array on return types ?
		value = self.TYPES_STRINGS[retval] if len(retval)==1 else retval[1:-1]
		self.return_type = value
	
	def __str__(self): 
		# short way just to graph test 1
		return "%s->%s" % (self.class_owner, self.method_name)
	def _strC(self):
		# complet str
		return "%s->%s(%s):%s" % (self.class_owner, self.method_name, ", ".join(self.parameters), self.return_type)

# invoke-direct or invoke-virtual aka function called
class Invoked(Smali_Function):
	# Constructor
	## 
	def __init__(self, smali_invoke_line):
		super(Invoked, self).__init__()
		self._extractOwnerClass(smali_invoke_line)
		self._extractMethodName(smali_invoke_line)
		self._extractCallParameters(smali_invoke_line)
		self._extractReturnType(smali_invoke_line)

	# Method class owner extractor
	## looking for foo/bar/baz
	def _extractOwnerClass(self, line):
		useful_parts = line.split(' ')[-1][1:]
		self.class_owner = useful_parts.split('-')[0][:-1]

	# Method name extractor
	## looking for qux
	def _extractMethodName(self, line):
		useful_parts = line.split(' ')[-1]
		useful_parts = useful_parts.split('->')[1]
		self.method_name = useful_parts.split('(')[0]

# location of function CALL aka class.method that makes the CALL
class Invoker(Smali_Function):
	# Constructor
	## 
	def __init__(self, ownerClass, smali_line):
		super(Invoker, self).__init__()
		self.class_owner = ownerClass
		self._extractMethodName(smali_line)
		self._extractCallParameters(smali_line)
		self._extractReturnType(smali_line)

	# Method name extractor
	## looking for qux
	def _extractMethodName(self, line):
		useful_parts = line.split(' ')[-1]
		#useful_parts = useful_parts.split('<')[0]
		self.method_name = useful_parts.split('(')[0]

# create and add edge and 2nodes with "style"
def addNodes(str1, str2):
	global graph
	node_a = pydot.Node(str1, style="filled", shape="box", color="#cccccc", fontname="Sans", fontsize=8)
	node_b = pydot.Node(str2, style="filled", shape="box", color="#cccccc", fontname="Sans", fontsize=8)
	graph.add_node(node_a)
	graph.add_node(node_b)
	graph.add_edge(pydot.Edge(node_a, node_b,color="#666666", arrowhead="open", weight=1))

# search for function (mode)references on dir/**/*.smali files
def run(dir, function, mode, verbose):
	global graph
	for root, subFolders, files in os.walk(dir):
		for file in files:
			if file.endswith(".smali"):
				eof=False
				fh = open(root+"/"+file, "r")
				while (not eof):
					line = fh.readline()
					eof = (len(line)==0)
					if (not eof):
						line = line[:-1]
						if len(line)>0:
							if re.search(".class public", line):
								vclass = line.split(' ')[-1][1:-1]
							elif re.search(".method ", line):
								new_caller = Invoker(vclass, line)
							elif re.search(".invoke-", line):
								new_call = Invoked(line)
								if mode == "XRefTo":
									if str(new_call) == function:
										addNodes(str(new_caller), str(new_call))
										if verbose:
											print "%s CALLS %s" % (new_caller._strC(), new_call._strC())
								elif mode == "XRefFrom": # XRefFrom
									if str(new_caller) == function:
										addNodes(str(new_caller), str(new_call))
										if verbose:
											print "%s CALLS %s" % (new_caller._strC(), new_call._strC())

				fh.close()

graph = pydot.Dot(graph_type='digraph', shape="record", simplify=True)

if __name__ == '__main__':

	## Parsing command line options
	modes = ['XRefTo','XRefFrom','XRefBoth']
	usage = "usage: %prog [options]"
	parser = OptionParser(usage=usage)
	parser.add_option("-d", "--dir", action="store", type="string", dest="smali_rootdir",
                  help="Smali code directory entry point.")
	parser.add_option("-m", "--mode", action="store", type="string", dest="graph_mode",
                  help="XRef Graph Type (XRefTo, XRefFrom and XRefBoth).")
	parser.add_option("-f", "--XRef", action="store", type="string", dest="ref_function",
                  help="XRef function name.")
	parser.add_option("-v", "--verbose",
                  action="store_true", dest="verbose", default=False,
                  help="Print complet function calls prototypes to stdout.")
	
	## Handling command line options errors.
	(options, args) = parser.parse_args()
	if (not options.smali_rootdir):
		parser.error("option -d is mandatory.")
	if (not options.ref_function):
		parser.error("Option -f is mandatory.")
	if (not options.graph_mode):
		graph_mode = "XRefBoth"
	elif ((options.graph_mode != "XRefTo") and (options.graph_mode != "XRefFrom") and (options.graph_mode != "XRefBoth") ):
		parser.error("Available Graph mode options are: XRefTo, XRefFrom and XRefBoth (case sensitive).")
	if options.verbose:
		verbose = True
	else:
		verbose = False

	## finaly basic values to work with!
	rootdir = options.smali_rootdir
	ref_function = options.ref_function
	graph_mode = options.graph_mode
	graph.set_rankdir('TB')
		
	# And now, main loop algorithm
	# initial node (function specified by user in -f option)
	if (graph_mode == "XRefTo") or (graph_mode == "XRefBoth"):
		run(rootdir, ref_function, "XRefTo", verbose)
	if (graph_mode == "XRefFrom") or (graph_mode == "XRefBoth"):
		run(rootdir, ref_function, "XRefFrom", verbose)

	graph.write_png('_xref.png')
