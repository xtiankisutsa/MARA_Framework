from core.logging.logger import Logger
from androguard.decompiler.dad import decompile


class SurgicalLibError(Exception):
    def __init__(self, message):
        self.logger = Logger()
        self.message = message
        self.logger.surgical_log("critical", "SurgicalLib : {}"
                                 .format(self.message))


class SurgicalLib(object):
    def __init__(self, target_module, vmx, vm, k, selection, methods):
        self.logger = Logger()
        self.target_module = target_module
        self.vmx = vmx
        self.vm = vm
        self.clazz = k
        self.selection = selection
        self.methods = methods

    def process_methods(self, found_methods):
        """
        Process and return a unique and analyzed list of methods based on usage
        findings.

        Args:
            param1: Discovered methods

        Returns:
            return: Processed methods
        """

        # Locals
        seen = set()
        unique = list()
        processed = list()

        try:
            for m in found_methods:
                if m.get_class_name() not in seen:
                    unique.append(m)
                    seen.add(m.get_class_name())
            for u in unique:
                if u.get_code():
                    analyzed = self.vmx.get_method(u)
                    src = decompile.DvMethod(analyzed)
                    src.process()
                    processed.append((u, analyzed, src.get_source()))
                else:
                    analyzed = self.vmx.get_method(u)
                    processed.append((u, analyzed, None))
            return processed
        except Exception as e:
            SurgicalLibError("process_methods : {}".format(e))
            if "Instruction31c" in e.message:
                pass

    def search(self):
        """
        Search for API usage within the target module

        Args:
            None

        Returns:
            return: Method
        """

        # Locals
        paths = None
        method = None
        found_methods = list()

        try:
            paths = self.vmx.get_tainted_packages().search_methods(self.clazz, self.selection, ".")
            if paths:
                for p in paths:
                    for method in self.methods:
                        if method.get_name() == p.get_src(self.vm.get_class_manager())[1]:
                            if method.get_class_name() == p.get_src(self.vm.get_class_manager())[0]:
                                found_methods.append(method)
            if found_methods:
                self.logger.surgical_log("info", "Results found (!)")
                process_methods = self.process_methods(found_methods)
                if process_methods:
                    return process_methods
            else:
                self.logger.surgical_log("info", "No results found (!)")
        except Exception as e:
            SurgicalLibError(e.message)
