from cmd2 import Cmd as Lobotomy
from core.logging.logger import Logger
from functools import wraps
from blessings import Terminal
from core.brains.utilities.util import Util
from os import path, listdir
from json import loads
from datetime import datetime
import readline
# DO NOT REMOVE
# Fix for cmd2 that enables command auto-complete
readline.parse_and_bind("bind ^I rl_complete")


class CommandError(Exception):
    def __init__(self, message):
        self.logger = Logger()
        self.message = message
        self.logger.log("critical", "Command : {}".format(self.message))


class CmdArgumentException(Exception):
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
                raise CmdArgumentException(cmdargs=args[0].split(" ")[0],
                                           doc=func.func_doc)
            return func(self, *args)
        return wrapper
    return decorator


class Run(Lobotomy):
    def __init__(self, ROOT_DIR):
        Lobotomy.__init__(self)
        self.ROOT_DIR = ROOT_DIR
        self.t = Terminal()
        self.logger = Logger()
        self.util = Util()
        self.apk = None
        self.package = None
        self.vm = None
        self.vmx = None
        self.gmx = None
        self.components = None
        self.dex = None
        self.strings = None
        self.permissions = None
        self.permissions_details = None
        self.files = None
        self.attack_surface = None

    def _cmd_completer(self, name, text, line, begidx, endidx):
        fn = getattr(self, 'do_'+name)
        if not hasattr(fn.im_func, "_expected_args"):
            return []
        a = [arg for arg in fn.im_func._expected_args if arg.startswith(text)]
        return a

    def find_dex(self):
        """
        Return True is classes.dex is found within the target APK.

        Args:
            None

        Returns:
            None
        """
        if self.files:
            for f in self.files:
                if "classes" in f:
                    return True
                    break

    def process_vm(self, apk=False, dex=False):
        """
        Process the application's classes.dex

        Args:
            param1 = boolean
            param2 = boolean

        Results:
            None
        """
        try:
            if apk:
                # Make sure the APK contains a classes.dex file
                if self.find_dex():
                    self.dex = self.apk.get_dex()
                    if self.dex:
                        self.logger.log("info", "Loading classes.dex ...")
                        from androguard.core.bytecodes.dvm import DalvikVMFormat
                        from androguard.core.analysis.analysis import VMAnalysis
                        from androguard.core.analysis.ganalysis import GVMAnalysis
                        # Create a DalvikVMFormat instance ...
                        # In this case self.dex will be a file type
                        self.vm = DalvikVMFormat(self.dex)
                        if self.vm:
                            print(self.t.yellow("\n\t--> Loaded classes.dex (!)\n"))
                            self.logger.log("info", "Analyzing classes.dex ...")
                            # Analyze the DalvikVMFormat instance and return
                            # analysis instances of VMAnalysis and GVMAnalysis
                            self.vmx = VMAnalysis(self.vm)
                            self.gmx = GVMAnalysis(self.vmx, None)
                            if self.vmx and self.gmx:
                                print(self.t.yellow("\n\t--> Analyzed classes.dex (!)\n"))
                                # Set the analysis properties on the
                                # DalvikVMFormat instance
                                self.vm.set_vmanalysis(self.vmx)
                                self.vm.set_gvmanalysis(self.gmx)
                                # Generate xref(s) and dref(s)
                                self.vm.create_xref()
                                self.vm.create_dref()
                                return
                            else:
                                CommandError("process_vm : Cannot analyze VM instance (!)")
                                return
                        else:
                            CommandError("process_vm : Cannot load VM instance (!)")
                            return
                    else:
                        CommandError("process_vm : classes.dex not found (!)")
                        return
            if dex:
                if self.dex:
                    from androguard.core.bytecodes.dvm import DalvikVMFormat
                    from androguard.core.analysis.analysis import VMAnalysis
                    from androguard.core.analysis.ganalysis import GVMAnalysis
                    # Analyze the DalvikVMFormat instance and return
                    # analysis instances of VMAnalysis and GVMAnalysis
                    self.vm = DalvikVMFormat(self.util.read(self.dex))
                    if self.vm:
                        print(self.t.yellow("\n\t--> Loaded {} (!)\n"
                                            .format(self.dex
                                                    .split("/")[-1])))
                        self.logger.log("info", "Analyzing {} ..."
                                        .format(self.dex
                                                .split("/")[-1]))
                        # Set the analysis properties on the
                        # DalvikVMFormat instance
                        self.vmx = VMAnalysis(self.vm)
                        self.gmx = GVMAnalysis(self.vmx, None)
                        if self.vmx and self.gmx:
                            print(self.t.yellow("\n\t--> Analyzed {} (!)\n"
                                                .format(self.dex
                                                        .split("/")[-1])))
                            # Set the analysis properties on the
                            # DalvikVMFormat instance
                            self.vm.set_vmanalysis(self.vmx)
                            self.vm.set_gvmanalysis(self.gmx)
                            # Generate xref(s) and dref(s)
                            self.vm.create_xref()
                            self.vm.create_dref()
                            return
                        else:
                            CommandError("process_vm :" +
                                         "Cannot analyze VM instance (!)")
                            return
                    else:
                        CommandError("process_vm :" +
                                     "Cannot load VM instance (!)")
                        return
                else:
                    CommandError("process_vm : classes.dex not found (!)")
                    return
        except Exception as e:
            CommandError("process_vm : {}".format(e))

    def complete_operate(self, *args):
        return self._cmd_completer("operate", *args)

    @cmd_arguments(["apk", "dex"])
    def do_operate(self, *args):
        """
        := operate apk path_to_apk
        := operate dex path_to_classes.dex
        """
        # Locals
        arg0 = args[0].split(" ")[0]
        arg1 = args[0].split(" ")[1]

        try:
            if arg0 == "apk":
                if arg1:
                    self.logger.log("info", "Loading : {} ..."
                                    .format(arg1.split("/")[-1]))
                    from androguard.core.bytecodes.apk import APK
                    self.apk = APK(arg1)
                    if self.apk:
                        print(self.t.yellow("\n\t--> Loaded : {} (!)\n"
                                            .format(arg1.split("/")[-1])))
                        self.package = self.apk.get_package()
                        from core.brains.apk.components import Components
                        # Load activies, services, broadcast receivers, and
                        # content providers
                        self.components = Components(self.apk)
                        self.components.enumerate_components()
                        self.permissions = self.apk.get_permissions()
                        self.files = self.apk.get_files()
                        self.files_type = self.apk.get_files_types()
                        # Process DVM
                        self.process_vm(apk=True)
                    else:
                        CommandError("APK not loaded (!)")
            elif arg0 == "dex":
                if arg1:
                    self.logger.log("info", "Loading : {} ..."
                                    .format(arg1.split("/")[-1]))
                    self.dex = arg1
                    self.process_vm(dex=True)
        except ImportError as e:
            CommandError("operate : {}".format(e))

    def complete_surgical(self, *args):
        return self._cmd_completer("surgical", *args)

    def do_surgical(self, *args):
        """
        := surgical
        """
        try:
            if self.vm and self.vmx:
                from .surgical import Run
                run = Run(self.vm, self.vmx)
                run.prompt = self.t.yellow("(surgical) ")
                run.ruler = self.t.yellow("-")
                run.cmdloop()
            else:
                CommandError("classes.dex not loaded (!)")
        except Exception as e:
            CommandError("surgical : {}".format(e))

    def complete_attacksurface(self, *args):
        return self._cmd_completer("attacksurface", *args)

    def do_attacksurface(self, *args):
        """
        := attacksurface
        """
        try:
            if self.apk and self.components:
                self.logger.log("info", "Loading attacksurface module ...")
                from core.brains.apk.attacksurface import AttackSurface
                self.attack_surface = AttackSurface(self.apk, self.components)
                self.attack_surface.run()
                # Helps with visual spacing after the results are printed
                print("\n")
        except ImportError as e:
            CommandError("attacksurface : {}".format(e))

    def complete_permissions(self, *args):
        return self._cmd_completer("permissions", *args)

    @cmd_arguments(["list"])
    def do_permissions(self, *args):
        """
        := permissions list
        """
        # Locals
        arg0 = args[0]

        try:
            if self.permissions:
                if args[0] == "list":
                    self.logger.log("info", "Loading permissions ... \n")
                    for p in self.permissions:
                        print(self.t.yellow("\t--> {}".format(p)))
                    print("\n")
            else:
                CommandError("Permissions not found (!)")
        except Exception as e:
            CommandError("permissions : {}".format(e))

    def complete_binja(self, *args):
        return self._cmd_completer("binja", *args)

    def do_binja(self, *args):
        """
        := binja
        """
        try:
            from .binja import Run
            run = Run(self.files, self.apk)
            run.prompt = self.t.cyan("(binja) ")
            run.ruler = self.t.cyan("-")
            run.cmdloop()
        except Exception as e:
            CommandError("binja : {}".format(e))



    def complete_files(self, *args):
        return self._cmd_completer("files", *args)

    @cmd_arguments(["all", "assets", "libs", "res"])
    def do_files(self, *args):
        """
        := files all
        := files assets
        := files libs
        := files res
        """
        # Locals
        arg0 = args[0]

        try:
            if self.files:
                if arg0 == "assets":
                    self.logger.log("info", "Loading files ... \n")
                    for f in self.files:
                        if f.startswith("assets"):
                            print(self.t.yellow("\t--> {}".format(f)))
                    print("\n")
                elif arg0 == "libs":
                    self.logger.log("info", "Loading files ... \n")
                    for f in self.files:
                        if f.startswith("lib"):
                            print(self.t.yellow("\t--> {}".format(f)))
                    print("\n")
                elif arg0 == "res":
                    self.logger.log("info", "Loading files ... \n")
                    for f in self.files:
                        if f.startswith("res"):
                            print(self.t.yellow("\t--> {}".format(f)))
                    print("\n")
                elif arg0 == "all":
                    self.logger.log("info", "Loading files ... \n")
                    for f in self.files:
                        print(self.t.yellow("\t--> {}".format(f)))
                    print("\n")
            else:
                CommandError("Files not populated (!)")
        except Exception as e:
            CommandError("files : {}".format(e))

    def complete_strings(self, *args):
        return self._cmd_completer("strings", *args)

    @cmd_arguments(["list", "search"])
    def do_strings(self, *args):
        """
        List and search for strings found in classes.dex

        := strings list
        := strings search
        """
        # Locals
        arg0 = args[0]
        strings = None

        try:
            if arg0 == "list":
                if self.vm:
                    strings = self.vm.get_strings()
                    if strings:
                        for s in strings:
                            print(self.t.cyan("--> {}".format(s.encode("utf-8", errors="ignore"))))
                    else:
                        CommandError("Strings not found (!)")
                else:
                    CommandError("classes.dex not loaded (!)")
            elif arg0 == "search":
                if self.vm:
                    strings = self.vm.get_strings()
                    if strings:
                        target = raw_input(self.t.yellow("\n\t--> Enter string : "))
                        for s in strings:
                            if target in s:
                                print(self.t.cyan("\t\t --> {}".format(s.encode("utf-8", errors="ignore"))))
                        print("\n")
                    else:
                        CommandError("Strings not found (!)")
                else:
                    CommandError("classes.dex not loaded (!)")
        except Exception as e:
            CommandError("strings : {}".format(e))

    def complete_components(self, *args):
        return self._cmd_completer("components", *args)

    @cmd_arguments(["list"])
    def do_components(self, *args):
        """
        := components list
        """
        # Locals
        arg0 = args[0]

        try:
            if arg0 == "list":
                if self.apk:
                    self.logger.log("info", "Enumerating components ...\n")
                    if self.components.activities:
                        for a in self.components.activities:
                            print(self.t.yellow("\t--> activity : {}"
                                                .format(a)))
                        print("\n")
                    if self.components.services:
                        for s in self.components.services:
                            print(self.t.yellow("\t--> service : {}"
                                                .format(s)))
                        print("\n")
                    if self.components.receivers:
                        for r in self.components.receivers:
                            print(self.t.yellow("\t--> receiver : {}"
                                                .format(r)))
                        print("\n")
                    if self.components.providers:
                        for r in self.components.providers:
                            print(self.t.yellow("\t--> provider : {}"
                                                .format(s)))
                        print("\n")
                else:
                    CommandError("APK not loaded (!)")
        except Exception as e:
            CommandError("components : {}".format(e))

    def complete_interact(self, *args):
        return self._cmd_completer("interact", *args)

    def do_interact(self, *args):
        """
        Drop into an interactive IPython session.

        := interact
        """
        try:
            if self.vm and self.vmx:
                from core.brains.interact.interact import Interact
                i = Interact(self.vm, self.vmx)
                i.run()
            else:
                CommandError("classes.dex not loaded (!)")
        except Exception as e:
            CommandError("interact : {}".format(e.message))

    def complete_class_tree(self, *args):
        return self._cmd_completer("class_tree", *args)

    def do_class_tree(self, *args):
        """
        := class_tree
        """
        try:
            if self.vm:
                for c in self.vm.get_classes():
                    # We don't care about Android support classes or resource
                    # classes
                    if c.name.startswith("Landroid") or \
                            c.name.split("/")[-1].startswith("R"):
                        continue
                    print("\n")
                    print(self.t.yellow("\t--> class : {} {}".format(c.get_access_flags_string(), c.name)))
                    for f in c.get_fields():
                        print(self.t.white("\t\t--> field : {} {} {}".format(f.get_access_flags_string(), f.get_descriptor(), f.name)))
                    for m in c.get_methods():
                        print(self.t.cyan("\t\t\t--> method : {} {} {}".format(m.get_access_flags_string(), m.name, m.get_descriptor())))
                print("\n")
            else:
                CommandError("class_tree : classes.dex not loaded (!)")
        except Exception as e:
            CommandError("class_tree : {}".format(e))

    def complete_native(self, *args):
        return self._cmd_completer("native", *args)

    def do_native(self, *args):
        """
        := native
        """
        # Locals
        native_methods = list()

        try:
            if self.vm:
                for method in self.vm.get_methods():
                    if method.get_access_flags() & 0x100:
                        native_methods.append((method.get_class_name(),
                                               method.get_name()))
                if native_methods:
                    print("\n")
                    for n in native_methods:
                        print(self.t.cyan("\t--> {} : {}".format(n[0], n[1])))
                    print("\n")
            else:
                self.logger.log("info",
                                "class_tree : classes.dex not loaded (!)")
        except Exception as e:
            CommandError("native : {}".format(e))

    def complete_ui(self, *args):
        return self._cmd_completer("ui", *args)

    def do_ui(self, *args):
        """
        := ui
        """
        try:
            if self.vm and self.vmx:
                from core.brains.ui.terminal import TerminalApp
                ui = TerminalApp(self.vm, self.vmx)
                ui.run()
        except Exception as e:
            CommandError("ui : {}".format(e))

    def complete_macro(self, *args):
        return self._cmd_completer("macro", *args)

    def do_macro(self, args):
        """
        := macro
        """
        # Locals
        directory_items = None
        macro = path.join(self.ROOT_DIR, "macro")
        selection = None
        apk_path = None
        json = None

        try:
            print("\n")
            directory_items = listdir(macro)
            for i, item in enumerate(directory_items):
                print(self.t.cyan("\t--> [{}] {}"
                                  .format(i, item)))
            print("\n")
            selection = raw_input(self.t.yellow("[{}] Select config : ".format(datetime.now())))
            try:
                index = int(selection)
            except ValueError:
                index = -1
            print("\n")
            if selection:
                for i, item in enumerate(directory_items):
                    if selection == item or i == index:
                        selection = item
                        break
                with open("".join([macro, "/", selection]), "rb") as config:
                    # Load the config as JSON
                    json = loads(config.read())
                    if json:
                        for k, v in json.items():
                            if k == "apk":
                                if v:
                                    apk_path = str(v)
                                    # Call operate() with the path to apk
                                    self.do_operate("apk {}"
                                                    .format(apk_path))
                                    return
                                else:
                                    CommandError("macro : Path to APK not found in {}"
                                                 .format(selection))
                            else:
                                CommandError("macro : Error loading {} as JSON"
                                             .format(selection))
        except Exception as e:
            CommandError("macro : {}".format(e))
