import npyscreen
from core.logging.logger import Logger
from androguard.core.bytecodes.dvm import ClassDefItem
from androguard.core.bytecodes.dvm import EncodedMethod
from pygments import highlight
from pygments.lexers.dalvik import SmaliLexer
from pygments.formatters import TerminalFormatter

# Global
# This global variables have to be accessed by the ClassTreeMultiSelect class
vm_global = None
vmx_global = None


class TerminalAppError(Exception):
    def __init__(self, message):
        self.logger = Logger()
        self.message = message
        self.logger.log("critical", "TerminalApp : {}".format(self.message))


class ClassTreeData(npyscreen.TreeData):

    def get_content_for_display(self):
        """
        Overidden from TreeData
        """
        if isinstance(self.content, str):
            return self.content
        elif isinstance(self.content, EncodedMethod):
            return self.content.name
        elif isinstance(self.content, ClassDefItem):
            return self.content.name
        else:
            return self.content


class TerminalMultiLine(npyscreen.MultiLine):
    def display_value(self, vl):
        """
        Overriden from npyscreen.MultiLine
        """
        try:
            return vl
        except ReferenceError as e:
            raise e


class ClassTreeMultiSelect(npyscreen.MLTreeMultiSelect):

    def handle_selected(self, vl):
        """
        Handle a selected method.

        Args:
            param1: TreeData

        Returns:
            None
        """

        # Locals
        m = None
        mx = None
        ml = None
        method_form = None
        basic_blocks = None

        try:
            if vl.selected:
                # Handle EncodedMethod type
                if isinstance(vl.get_content(), EncodedMethod):
                    m = vl.get_content()
                    mx = vmx_global.get_method(m)
                    if m.get_code():
                        idx = 0
                        basic_blocks = mx.get_basic_blocks().get()
                        method_form = npyscreen.Form(name=m.name,
                                                     framed=False)
                        # Our custom MultiLine class for handling displaying
                        # the values
                        ml = method_form.add(TerminalMultiLine,
                                             autowrap=False)
                        ml.values.append("{} {}"
                                         .format(m.get_access_flags_string(),
                                                 m.name))
                        # This provide a visual space
                        ml.values.append("")
                        for block in basic_blocks:
                            for i in block.get_instructions():
                                ml.values.append(" ".join([str(idx),
                                                           i.get_name(),
                                                           i.get_output()]))
                                idx += i.get_length()
                        method_form.edit()
                        return
                # Handle ClassDefItem type
                if isinstance(vl.get_content(), ClassDefItem):
                    return
        except Exception as e:
            raise e

    def h_select(self, ch):
        """
        Overidden from npyscreen.MLTreeMultiSelect
        """
        # DO NOT MODIFY (!)
        vl = self.values[self.cursor_line]
        vl_to_set = not vl.selected
        if self.select_cascades:
            for v in self._walk_tree(vl, only_expanded=False,
                                     ignore_root=False):
                if v.selectable:
                    v.selected = vl_to_set
        else:
            vl.selected = vl_to_set
        if self.select_exit:
            self.editing = False
            self.how_exited = True
        self.display()
        # Handle the selection
        self.handle_selected(vl)


class TerminalForm(npyscreen.Form):
    def create(self):
        """
        Overidden from npyscreen.Form
        """
        # Locals
        self.how_exited_handers[
            npyscreen.wgwidget.EXITED_ESCAPE] = self.exit_application

    def exit_application(self):
        """
        Overidden from npyscreen.Form
        """
        # Locals
        self.parentApp.setNextForm(None)
        self.editing = False


class TerminalApp(npyscreen.NPSApp):
    def __init__(self, vm, vmx):
        # Wut?
        # Get the DVM and Analysis instance and make them global
        global vm_global
        vm_global = vm
        global vmx_global
        vmx_global = vmx

    def main(self):
        """
        Overriden from npyscreen.NPSApp
        """

        # Locals
        lterm_form = None
        tree = None
        tree_data = None
        clazz = None
        method = None

        lterm_form = TerminalForm(name="lterm", framed=False)
        tree = lterm_form.add(ClassTreeMultiSelect)
        tree_data = ClassTreeData(content="Class Tree", selectable=False,
                                  ignore_root=False)
        try:
            for c in vm_global.get_classes():
                # Don't populate the Android support classes
                if c.name.startswith("Landroid"):
                    continue
                # If selected is set to True, it will populate the results
                # from get_selected_objects, we don't want this
                clazz = tree_data.new_child(content=c,
                                            selectable=False, selected=False)
                for m in c.get_methods():
                    method = clazz.new_child(content=m,
                                             selectable=True, selected=False)
            tree.values = tree_data
            lterm_form.edit()
        except Exception as e:
            TerminalAppError("main : {}".format(e))
