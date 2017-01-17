from cmd2 import Cmd as SurgicalCmd
from core.logging.logger import Logger
from functools import wraps
from blessings import Terminal
from datetime import datetime
from core.brains.utilities.util import Util
from core.brains.surgical.modules.intent import IntentModule
from core.brains.surgical.modules.zip import ZipModule
from core.brains.surgical.modules.socket import SocketModule
from core.brains.surgical.modules.system import SystemModule
from core.brains.surgical.modules.crypto import CryptoModule
from pygments import highlight
from pygments.lexers import JavaLexer
from pygments.formatters import TerminalFormatter
import readline
# DO NOT REMOVE
# Fix for cmd2 that enables command auto-complete
readline.parse_and_bind("bind ^I rl_complete")


class SurgicalError(Exception):
    def __init__(self, message):
        self.logger = Logger()
        self.message = message
        self.logger.log("critical", "Surgical : {}".format(self.message))


class SurgicalCmdArgumentException(Exception):
    def __init__(self, cmdargs=None, doc=""):
        self.t = Terminal()
        if not cmdargs:
            cmdargs = None
        self.cmdargs = cmdargs
        self.doc = doc

    def __str__(self):
        msg = [self.doc]
        if self.cmdargs:
            msg.insert(0, "\n\t{0} : {1} (!)".format("Command not found",
                                                     self.cmdargs))
        return "\n\n".join(msg)


def cmd_arguments(expected_args):
    def decorator(func):
        func._expected_args = expected_args
        @wraps(func)
        def wrapper(self, *args):
            if args[0].split(" ")[0] not in expected_args:
                raise SurgicalCmdArgumentException(cmdargs=args[0].split(" ")[0],
                                                   doc=func.func_doc)
            return func(self, *args)
        return wrapper
    return decorator


class Run(SurgicalCmd):
    def __init__(self, vm, vmx):
        SurgicalCmd.__init__(self)
        self.logger = Logger()
        self.t = Terminal()
        self.u = Util()
        self.vm = vm
        self.vmx = vmx
        self.methods = self.vm.get_methods()
        self.intent = IntentModule()
        self.zip = ZipModule()
        self.socket = SocketModule()
        self.system = SystemModule()
        self.crypto = CryptoModule()
        self.modules = [m for m in self.zip,
                        self.intent,
                        self.socket,
                        self.system,
                        self.crypto]
        self.target_module = None
        self.methods_api_usage = list()

    def _cmd_completer(self, name, text, line, begidx, endidx):
        fn = getattr(self, 'do_'+name)
        if not hasattr(fn.im_func, "_expected_args"):
            return []
        a = [arg for arg in fn.im_func._expected_args if arg.startswith(text)]
        return a

    def complete_modules(self, *args):
        return self._cmd_completer("modules", *args)

    @cmd_arguments(["list", "select"])
    def do_modules(self, *args):
        """
        List and select target API modules.

        := modules list
        := modules select
        """
        # Locals
        arg0 = args[0]
        selection = None

        try:
            if arg0 == "list":
                if self.modules:
                    print("\n")
                    for i, m in enumerate(self.modules):
                        print(self.t.cyan("\t--> [{}] {}"
                                          .format(i, m.name)))
                    print("\n")
            if arg0 == "select":
                if self.modules:
                    selection = raw_input(self.t.yellow("[{}] ".format(datetime.now())) + "Select module : ")
                    try:
                        index = int(selection)
                    except ValueError:
                        index = -1
                    for i, m in enumerate(self.modules):
                        if selection == m.name or i == index:
                            self.target_module = m
                            break
                    self.logger.surgical_log("info", "{} module selected (!)"
                                             .format(self.target_module.name))
        except Exception as e:
            SurgicalError(e.message)

    def complete_api(self, *args):
        return self._cmd_completer("api", *args)

    @cmd_arguments(["list", "select", "analyzed"])
    def do_api(self, *args):
        """
        List and select methods from a given loaded API module

        := api list
        := api select
        := api analyzed list
        := api analyzed select
        """
        # Locals
        arg0 = args[0].split(" ")[0]
        arg1 = None
        class_selection = None
        method_selection = None
        surgical_lib = None

        try:
            # List the available API methods from the target module
            if arg0 == "list":
                if self.target_module:
                    print("\n")
                    for k, v in self.target_module.model.values.items():
                        print("\n")
                        for m in v:
                            print(self.t.cyan("\t--> {} : {} : {}"
                                              .format(self.target_module.name,
                                                      k.split(".")[-1], m)))
                    print("\n")
                else:
                    self.logger.surgical_log("info", "Target module has not been loaded (!)")
            # Select an API method from the target module
            elif arg0 == "select":
                if self.target_module:
                    # TODO Consider building a wrapper around raw_input()
                    class_selection = raw_input(self.t.yellow("[{}] ".format(datetime.now())) + "Select class : ")
                    method_selection = raw_input(self.t.yellow("[{}] ".format(datetime.now())) + "Select method : ")
                    for k, v in self.target_module.model.values.items():
                        # This is so we can support classes with identical
                        # method names --> Ex: java.util.zip.ZipFile
                        if class_selection == k.split(".")[-1]:
                            for m in v:
                                if m == method_selection:
                                    self.logger.surgical_log("info",
                                                             "Analyzing ...")
                                    from core.brains.surgical.lib.libsurgical import SurgicalLib
                                    # Begin processing and return the results
                                    # from the selected api
                                    surgical_lib = SurgicalLib(self.target_module,
                                                               self.vmx,
                                                               self.vm,
                                                               k,
                                                               method_selection,
                                                               self.methods)
                                    # methods_api_usage will contain a list of
                                    # tuples
                                    self.methods_api_usage = surgical_lib.search()
                                else:
                                    self.logger.surgical_log("warn", "Method not found (!)")
            # Analyze the processed method list
            elif arg0 == "analyzed":
                if args[0].split(" ")[1]:
                    arg1 = args[0].split(" ")[1]
                    # List the methods that have been processed
                    if arg1 == "list":
                        if self.methods_api_usage:
                            print("\n")
                            for i, m in enumerate(self.methods_api_usage):
                                print(self.t.cyan("\t--> [{}] {} -> {} "
                                                  .format(i, m[0].class_name,
                                                          m[0].name)))
                            print("\n")
                        else:
                            SurgicalError("API usage not found (!)")
                # Select from the processed method list
                elif arg1 == "select":
                    if self.methods_api_usage:
                        selection = raw_input(self.t.yellow("[{}] ".format(datetime.now())) + "Select method : ")
                        try:
                            index = int(selection)
                        except ValueError:
                            index = -1
                        for i, m in enumerate(self.methods_api_usage):
                            if selection == m[0].name or i == index:
                                print("\n")
                                print(self.t.cyan("\t--> Class : {}".format(m[0].class_name)))
                                print(self.t.cyan("\t\t--> Method : {}".format(m[0].name)))
                                print(self.t.cyan("\t\t\t --> XREFS ###########"))
                                self.u.print_xref("T", m[1].method.XREFto.items)
                                self.u.print_xref("F", m[1].method.XREFfrom.items)
                                print("\n")
                                print(highlight(m[2],
                                                JavaLexer(),
                                                TerminalFormatter()))
                    else:
                        SurgicalError("API usage not found (!)")
        except Exception as e:
            SurgicalError(e.message)
