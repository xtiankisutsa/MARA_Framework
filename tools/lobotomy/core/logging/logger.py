from blessings import Terminal
from datetime import datetime


class Logger(object):
    def __init__(self):
        self.t = Terminal()

    def log(self, t, m):
        """
        Log a message to the console.

        Args:
            param1: Type of log {info, warn, critical}
            param2: Log message

        Returns:
            None
        """
        if t == "info":
            print(self.t.green("[{}] ".format(datetime.now())) +
                  "{}".format(m))
        if t == "warn":
            print(self.t.yellow("[{}] ".format(datetime.now())) +
                  self.t.white("{}".format(m)))
        elif t == "critical":
            print(self.t.red("[{}] ".format(datetime.now())) +
                  self.t.white("{}".format(m)))

    def surgical_log(self, t, m):
        """
        Log a message to the console.

        Args:
            param1: Type of log {info, warn, critical}
            param2: Log message

        Returns:
            None
        """
        if t == "info":
            print(self.t.yellow("[{}] ".format(datetime.now())) + "{}".format(m))
        elif t == "critical":
            print(self.t.red("[{}] ".format(datetime.now())) +
                  self.t.white("{}".format(m)))

    def binja_log(self, t, m):
        """
        Log a message to the console.

        Args:
            param1: Type of log {info, warn, critical}
            param2: Log message

        Returns:
            None
        """
        if t == "info":
            print(self.t.cyan("[{}] ".format(datetime.now())) + "{}".format(m))
        elif t == "critical":
            print(self.t.red("[{}] ".format(datetime.now())) + self.t.white("{}".format(m)))
