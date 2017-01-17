from core.logging.logger import Logger
from blessings import Terminal


class ComponentsError(Exception):
    def __init__(self, message):
        self.logger = Logger()
        self.message = message
        self.logger.log("critical", "Components : {}".format(self.message))


class Components(object):
    def __init__(self, apk):
        self.logger = Logger()
        self.t = Terminal()
        self.apk = apk
        self.activities = list()
        self.services = list()
        self.receivers = list()
        self.providers = list()

    def sort_unique(self):
        """
        """
        return

    def enumerate_components(self):
        """
        Enumerate the activities, broadcast receivers, services, and
        content providers from the target application's AndroidManifest.xml.

        Args:
            None

        Returns:
            None
        """
        # TODO List comprehension
        # This is ugly fucking code ...
        self.logger.log("info", "Loading components ...\n")
        try:
            if self.apk.get_activities():
                for a in self.apk.get_activities():
                    self.activities.append(a)
                if self.activities:
                    print(self.t.yellow("\t--> Loaded activities (!)"))
            if self.apk.get_services():
                for s in self.apk.get_services():
                    self.services.append(s)
                if self.services:
                    print(self.t.yellow("\t--> Loaded services (!)"))
            if self.apk.get_receivers():
                for r in self.apk.get_receivers():
                    self.receivers.append(r)
                if self.receivers:
                    print(self.t.yellow("\t--> Loaded receivers (!)"))
            if self.apk.get_providers():
                for p in self.apk.get_providers():
                    self.providers.append(p)
                if self.providers:
                    print(self.t.yellow("\t--> Loaded providers (!)"))
            print("\n")
            self.logger.log("info", "Finished loading components ...")
        except Exception as e:
            ComponentsError(e.message)
