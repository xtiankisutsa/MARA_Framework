from blessings import Terminal
from xml.dom.minidom import parseString
from pygments import highlight
from pygments.lexers.html import XmlLexer
from pygments.formatters import TerminalFormatter


class Util(object):
    def __init__(self):
        self.t = Terminal()

    @staticmethod
    # This probably does not need to be static
    def read(filename, binary=True):
        with open(filename, 'rb' if binary else 'r') as f:
            return f.read()

    def print_xref(self, tag, items):
        for i in items:
            print(self.t.cyan("\t\t\t\t{}: {} {} {} {}".format(
                tag,
                i[0].get_class_name(),
                i[0].get_name(),
                i[0].get_descriptor(),
                " ".join("%x" % j.get_idx() for j in i[1]))))

    def pretty_print_xml(self, xml):
        print(highlight(xml.toprettyxml(), XmlLexer(), TerminalFormatter()))
