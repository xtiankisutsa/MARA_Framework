from cmd2 import Cmd as Binja
from blessings import Terminal
from core.logging.logger import Logger
from elftools.elf.elffile import ELFFile
from elftools.elf.sections import SymbolTableSection
from cStringIO import StringIO
from functools import wraps
from datetime import datetime
import readline
import xmlrpclib
import os
# DO NOT REMOVE
# Fix for cmd2 that enables command auto-complete
readline.parse_and_bind("bind ^I rl_complete")


class BinjaError(Exception):
    def __init__(self, message):
        self.logger = Logger()
        self.message = message
        self.logger.log("critical", "Command : {}".format(self.message))


class BinjaCmdArgumentException(Exception):
    def __init__(self, cmdargs=None, doc=""):
        self.t = Terminal()
        if not cmdargs:
            cmdargs = None
        self.cmdargs = cmdargs
        self.doc = doc

    def __str__(self):
        msg = [self.doc]
        if self.cmdargs:
            msg.insert(0, "\n\t{0} : {1} (!)".format("Command not found", self.cmdargs))
        return "\n\n".join(msg)


def cmd_arguments(expected_args):
    def decorator(func):
        func._expected_args = expected_args
        @wraps(func)
        def wrapper(self, *args):
            if args[0].split(" ")[0] not in expected_args:
                raise BinjaCmdArgumentException(cmdargs=args[0].split(" ")[0], doc=func.func_doc)
            return func(self, *args)
        return wrapper
    return decorator


class Run(Binja):
    def __init__(self, files, apk):
        Binja.__init__(self)
        self.t = Terminal()
        self.logger = Logger()
        self.files = files
        self.apk = apk
        self.libs = list()
        self.rpc = None
        self.target_library = None
        self._init_binja()

    def _cmd_completer(self, name, text, line, begidx, endidx):
        fn = getattr(self, 'do_'+name)
        if not hasattr(fn.im_func, "_expected_args"):
            return []
        a = [arg for arg in fn.im_func._expected_args if arg.startswith(text)]
        return a

    def _init_binja(self):
        """
        Initialize the Binja module
        """
        # Locals
        endpoint = "http://localhost:6666/lobotomy"
        stream = None

        try:
            if self.files:
                for f in self.files:
                    if f.startswith("lib"):
                        stream = StringIO(self.apk.get_file(f))
                        self.libs.append((stream, f))
                    else:
                        continue
                # If we have shared-libraries, connect to binja's XMLRPC endpoint
                if self.libs:
                    self.logger.binja_log("info", "Found shared-libraries (!)")
                    # List of tuples
                    print("\n")
                    for l in self.libs:
                        print("\t--> {}".format(l[1]))
                    print("\n")
                    # Make a selection ...
                    # Make connection
                    self.rpc = xmlrpclib.ServerProxy(endpoint)
                    self.logger.binja_log("info", "Connected to XMLRPC endpoint (!)")
                else:
                    self.logger.binja_log("info", "shared-libraries not found (!)")
                    return
            else:
                self.logger.binja_log("info", "Files not found (!)")
                return
        except Exception as e:
            BinjaError("init : {}".format(e))

    def complete_jni(self, *args):
        return self._cmd_completer("binja", *args)

    def do_jni(self, *args):
        """
        := jni
        """
        # Locals
        results = None

        try:
            results = self.rpc.jni()
            if results:
                self.logger.binja_log("info", "Found JNI functions (!)")
                print("\n")
                for f in results:
                    print("\t--> {}".format(f))
                print("\n")
            else:
                self.logger.binja_log("Registered JNI functions not found (!)")
        except Exception as e:
            BinjaError("jni : {}".format(e))

    def complete_libraries(self, *args):
        return self._cmd_completer("libraries", *args)

    @cmd_arguments(["list", "select"])
    def do_libraries(self, *args):
        """
        := libraries select
        """
        # Locals
        arg0 = args[0]
        selection = None
        index = None

        try:
            if self.libs:
                if arg0 == "list":
                    print("\n")
                    for i, lib in enumerate(self.libs):
                        print("\t--> [{}] {} ".format(i, lib[1].split("/")[-1]))
                    print("\n")
                if arg0 == "select":
                    print("\n")
                    for i, lib in enumerate(self.libs):
                        print("\t--> [{}] {} ".format(i, lib[1].split("/")[-1]))
                    print("\n")
                    selection = raw_input("[{}] Select library : ".format(datetime.now()))
                    try:
                        index = int(selection)
                    except ValueError:
                        index = -1
                    if selection:
                        for i, lib in enumerate(self.libs):
                            if selection in lib[1] or i == index:
                                self.target_library = lib
                                self.logger.binja_log("info", "Selected {} (!)".format(self.target_library[1].split("/")[-1]))
                                break
        except Exception as e:
            BinjaError("library : {}".format(e))

    def complete_symbols(self, *args):
        return self._cmd_completer("symbols", *args)

    def do_symbols(self, *args):
        """
        := symbols
        """
        # Locals
        elf = None

        try:
            if self.target_library:
                # Create a new ELFFile() instance
                elf = ELFFile(self.target_library[0])
                for section in elf.iter_sections():
                    # Once we find the symbol table, print each symbol
                    if isinstance(section, SymbolTableSection):
                        self.logger.binja_log("info", "Found symbol table (!)")
                        for i, symbol in enumerate(section.iter_symbols()):
                            self.logger.binja_log("info", symbol.name)
            else:
                self.logger.binja_log("info", "Target library not selected (!)")
        except Exception as e:
            BinjaError("function : {}".format(e))
