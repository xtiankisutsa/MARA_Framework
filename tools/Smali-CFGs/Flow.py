import re
import sys
import pydot
from optparse import OptionParser

class GraphManager(object):
	""" pydot graph objects manager """
	def __init__(self):
		self.graph = pydot.Dot(graph_type='digraph', simplify=True)

	def add_edge(self, b1, b2, label="CONT"):
		""" join two pydot nodes / create nodes edge """
		# Edge color based on label text
		if label=='false':
			ecolor = "red"
		elif label=='true':
			ecolor = 'green'
		elif label == 'exception':
			ecolor = 'orange'
		elif label == 'try':
			ecolor = 'blue'
		else:
			ecolor = 'gray'
		# node shape based on block type (First or Last instruction)
		nodes = [None, None]
		blocks = [b1,b2]
		for i in range(2):
			if Block.isTag(blocks[i].instructions[-1], 'isConditional'):
				ncolor = "cornflowerblue"
			elif Block.isTag(blocks[i].instructions[0], 'isLabel'):
				ncolor = "tan"
			elif Block.isTag(blocks[i].instructions[-1], 'isJump'):
				ncolor = "darkgreen"
			elif Block.isTag(blocks[i].instructions[-1],'isCall'):
				ncolor = "lightyellow4"
			else:
				ncolor = "mediumaquamarine"
			nodes[i] = pydot.Node(b1.label, color=ncolor, style="filled", shape="box", fontname="Courier", fontsize="8")
			bis="%s\l%s\l" % (blocks[i].label, "\l".join(blocks[i].instructions))
			nodes[i].set_name(bis)
			self.graph.add_node(nodes[i])

		ed = pydot.Edge(nodes[0], nodes[1], color=ecolor, label=label, fontname="Courier", fontsize="8", arrowhead="open")
		self.graph.add_edge(ed)

	def draw(self, name):
		self.graph.write_png(name)

class Block(object):
	""" Sequential group of instructions """
	def __init__(self, parent_class=None, parent_method=None, label=None, instructions=None):
		"""
			Parameters:
				parent_class: Class where our code is located.
				parent_method: Class method where our code is located.
				label: Block identifier (class name[space]method name[space]first line offset).
				instructions: list raw instructions
				targets: Code flow changes targets, if any.
		"""
		self.parent_class = parent_class
		self.parent_method = parent_method
		self.label = label
		self.instructions = instructions
		self.targets = []

	@staticmethod
	def isTag(inst, ttype):
		""" Indicates whether the specified code line contains an known instruction. """
		if ttype == 'isMethodBegin':
			match = re.search("^.method ", inst)
		elif ttype == 'isMethodEnd':
			match = re.search("^.end method", inst)
		elif ttype == 'isJump':
			match = re.search("^goto", inst)
		elif ttype == 'isConditional':
			match = re.search("^if-", inst)
		elif ttype == 'isCatch':
			match = re.search("^.catch ", inst)
		elif ttype == 'isLabel':
			#match = re.search("^\:" , inst) and ((not re.search("^\:try" , inst)) and (not re.search("^\:catch" , inst)))
			match = re.search("^\:" , inst)
		elif ttype == 'isReturn':
			match = re.search("^return-", inst)
		elif ttype == 'isCall':
			match = re.search("^invoke-", inst)			
		else:
			match = None
		if match:
			return True
		else:
			return False

	def add_inst(self, inst):
		""" Just add one instruction to our set of instructions. """
		self.instructions.append(inst)

	def isNeighbor(self, block):
		""" Specified block is at the same class and method ? """
		return (block.parent_class  == self.parent_class) and (block.parent_method == self.parent_method)

	def getLength(self, inc=0):
		return len(self.instructions) + inc

class BlockFactory(object):
	def __init__(self):
		self.blocks = []

	def add(self, blk):
		global graph
		""" Add the block to our blocks list if it is not present and have at least one instruction. """
		if (not (blk in self.blocks)) and (len(blk.instructions)>0):
			self.blocks.append(blk)

	def add_before(self, label=None, inst=None, block=None, pclass=None, pmethod=None):
		""" Add instruction to the current block, and then add this to our blocks list. """
		block.add_inst(inst)
		self.add(block)
		return Block(label=label, instructions=[], parent_class=pclass, parent_method=pmethod)

	def add_after(self, label=None, inst=None, block=None, pclass=None, pmethod=None):
		""" Add the block to our list, and make a new one with the specified instructions. """
		self.add(block)
		b = Block(label=label, instructions=[inst], parent_class=pclass, parent_method=pmethod)
		return b

	@staticmethod
	def xtractBlock(classfile, functionname):
		""" split smali class file into method/s code lines. """
		# read class file contents
		fh = open(classfile, "r")
		fc = fh.read()
		fh.close()
		# extract method raw lines
		methods = []
		for m in re.findall("\.method\s(.*?)\n(.*?)\.end\smethod", fc, re.DOTALL):
			if functionname is not None:
				if m[0].split(' ')[-1].split('(')[0] == functionname:
					methods.append(m)
					break
			else:
				methods.append(m)
		# remove empty lines
		if len(methods) == 0:
			return None
		else:
			ret = []
			for m in methods:
				instructions = []
				for inst in m[1].split("\n"):
					if len(inst)>0:
						instructions.append( inst.lstrip() )
				mname = m[0].split(' ')[-1].split('(')[0]
				ret.append((mname,instructions))
			# All done!
			return ret

	@staticmethod
	def splitBlock(blk, classn, methodn, pos, lenInc, iset, i):
		blockLen = len(blk.instructions) + lenInc
		incrementalLabel = "%s %s %d" % (classn, methodn, pos+blockLen)
		if not Block.isTag(i, 'isCall'):
			positionalLabel  = "%s %s %d" % (classn, methodn, iset.index(i.split(' ')[-1])+1 )
		else:
			lindex = int(blk.label.split(' ')[-1]) + len(blk.instructions)
			positionalLabel = " ".join(blk.label.split(' ')[:-1]) + " " + str(lindex+1)
		return (incrementalLabel, positionalLabel)

### main block xtraction from smali class file.
# 1.- block for specified method.
# 2.- blocks for all methods inside class file.
def smaliFileReader(file, method):
	methodInstructions = BlockFactory.xtractBlock(filename, methodname)
	if methodInstructions is not None:
		methods.append((classname, methodInstructions[0], methodInstructions[1]))


if __name__ == '__main__':

	## Parsing command line options
	modes = ['XRefTo','XRefFrom','XRefBoth']
	usage = "usage: %prog [options]"
	parser = OptionParser(usage=usage)
	parser.add_option("-c", "--class", action="store", type="string", dest="filename",
                  help="Smali class file.")
	parser.add_option("-m", "--method", action="store", type="string", dest="methodname",
                  help="Class method to analyze).")
	
	## Handling command line options errors.
	(options, args) = parser.parse_args()
	if (not options.filename):
		parser.error("option -c is mandatory.")

	graph_mgr = GraphManager()
	methods = []
	classname = "/".join(options.filename.split('.')[0].split('/')[1:])
	methodInstructions = BlockFactory.xtractBlock(options.filename, options.methodname)
	if methodInstructions is not None:
		for mnam, minst in methodInstructions:
			methods.append((classname, mnam, minst))

	## linear pass 1
	# split method code block into smaller blocks (calls/jumps/conditionals/labeled/catch)
	# calculate block target/s.
	factory = BlockFactory()
	for (cname, mname, minsts) in methods:
		# default initial block
		b = Block(label=cname + " " + mname + " 1", instructions=[], parent_class = cname, parent_method = mname)
		for i2 in minsts:
			instrPos = minsts.index(i2) + 1
			blockPos = int(b.label.split(' ')[-1])
			if Block.isTag(i2, 'isJump'):
				(incLabel, posLabel) = BlockFactory.splitBlock(b, cname, mname, blockPos, 1, minsts, i2)
				b.targets = [('jump',posLabel)]
				b = factory.add_before(label=incLabel, inst=i2, block=b, pclass=cname, pmethod=mname)
			elif Block.isTag(i2, 'isConditional'):
				(incLabel, posLabel) = BlockFactory.splitBlock(b, cname, mname, blockPos, 1, minsts, i2)
				b.targets = [('true',posLabel), ('false',incLabel)]
				b = factory.add_before(label=incLabel, inst=i2, block=b, pclass=cname, pmethod=mname)
			elif Block.isTag(i2, 'isLabel'):
				(incLabel, posLabel) = BlockFactory.splitBlock(b, cname, mname, blockPos, 0, minsts, i2)
				b.targets = [('cont',incLabel)]
				b = factory.add_after(label=incLabel, inst=i2, block=b, pclass=cname, pmethod=mname)
			elif Block.isTag(i2, 'isCatch'):
				(incLabel, posLabel) = BlockFactory.splitBlock(b, cname, mname, blockPos, 1, minsts, i2)
				b.targets = [('exception',posLabel), ('try',incLabel)]
				b = factory.add_before(label=incLabel, inst=i2, block=b, pclass=cname, pmethod=mname)			
			elif Block.isTag(i2, 'isCall'):
				(incLabel, posLabel) = BlockFactory.splitBlock(b, cname, mname, blockPos, 1, minsts, i2)
				b.targets = [('on return',posLabel)]
				b = factory.add_before(label=incLabel, inst=i2, block=b, pclass=cname, pmethod=mname)
			else:
				b.add_inst(i2)
		factory.add(b)

	## linear pass 2
	# joining graph nodes !
	for b1 in factory.blocks:
		for lbl,target in b1.targets:
			for b2 in factory.blocks:
				if b2.label == target:
					graph_mgr.add_edge(b1,b2, lbl)
					break

	graph_mgr.draw('_flow.png')
