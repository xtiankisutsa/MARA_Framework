from binaryninja import PluginCommand
from SimpleXMLRPCServer import SimpleXMLRPCServer
from SimpleXMLRPCServer import SimpleXMLRPCRequestHandler
import threading

# Globals
t = None
running = False


class ExceptionHandler(Exception):
    def __init__(self, message):
        self.message = message
        print(message)


class LobotomyRequestHandler(SimpleXMLRPCRequestHandler):
    rpc_paths = ('/lobotomy',)


class Lobotomy:
    def __init__(self, server, bv):
        self.server = server
        self.bv = bv

    def jni(self):
        """
        Find all the registered JNI functions
        """
        # Locals
        jni_found = list()

        for func in self.bv.functions:
            # TODO replace with regex
            if func.name.startswith("Java") or \
                    func.name.startswith("JNI") or \
                    func.name.startswith("java"):
                jni_found.append(func.name)
        return jni_found


def start_lobotomy(bv):
    """
    Start the lobotomy service
    """
    # Locals
    HOST = "127.0.0.1"
    PORT = 6666
    rpc = None

    try:
        # Create a new SimpleXMLRPCServer instance with the
        # LobotomyRequestHandler
        rpc = SimpleXMLRPCServer((HOST, PORT),
                                 requestHandler=LobotomyRequestHandler,
                                 logRequests=False,
                                 allow_none=True)
        # Register the Lobotomy class
        rpc.register_instance(Lobotomy(rpc, bv))
        print("[*] Started lobotomy service (!)")
        while True:
            # Handle inbound requests
            rpc.handle_request()
    except Exception as e:
        ExceptionHandler(e)


def start_thread(bv):
    """
    Create a new thread that will run the lobotomy service
    """
    global t
    global running

    print(bv)
    try:
        t = threading.Thread(target=start_lobotomy, args=[bv])
        t.daemon = True
        t.start()
        if not running:
            running = True
    except Exception as e:
        ExceptionHandler(e)


# Register plugin
PluginCommand.register("jni", "Find all registered JNI functions",
                       start_thread)
