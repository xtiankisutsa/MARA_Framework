from core.logging.logger import Logger
from blessings import Terminal


class AttackSurfaceError(Exception):
    def __init__(self, message):
        self.logger = Logger()
        self.message = message
        self.logger.log("critical", "AttackSurface : {}".format(self.message))


class AttackSurface(object):
    def __init__(self, apk, components):
        self.t = Terminal()
        self.logger = Logger()
        self.apk = apk
        self.xml = self.apk.get_AndroidManifest()
        # Populate XML elements
        self.xml_activities = self.xml.getElementsByTagName("activity")
        self.xml_services = self.xml.getElementsByTagName("service")
        self.xml_receivers = self.xml.getElementsByTagName("receiver")
        self.xml_providers = self.xml.getElementsByTagName("provider")
        self.components = components

    def activities(self):
        """
        Analyze the attack surface for activities
        """
        filters = None
        # TODO Enumerate the permission attribute for the activity element
        for a in self.components.activities:
            filters = self.apk.get_intent_filters("activity", a)
            if self.xml_activities:
                for activity in self.xml_activities:
                    # Match the element name with the component name
                    if activity.getAttribute("android:name") == a \
                            or activity.getAttribute("android.name").split(".")[-1] == a.split(".")[-1]:
                        # Find the android:exported element attribute
                        if activity.getAttribute("android:exported"):
                            # Determine if the attribute is set to true
                            if activity.getAttribute("android:exported") == "true":
                                print(self.t.yellow("\n\t--> activity : {}".format(a)))
                                if activity.getAttribute("android:permission"):
                                    print(self.t.red("\t\t--> permission : {}".format(activity.getAttribute("android:permission"))))
                                # Enumerate the intent filters for the give activity
                                filters = self.apk.get_intent_filters("activity", a)
                                if filters:
                                    # Enumerate the intent filter's action and category
                                    # elements
                                    for key, values in filters.items():
                                        if key == "action":
                                            for value in values:
                                                print(self.t.yellow("\t\t--> action : {}".format(value)))
                                        if key == "category":
                                            for value in values:
                                                print(self.t.yellow("\t\t--> category : {}".format(value)))
                                    # Pull data schemes from XML
                                    intents = activity.getElementsByTagName("intent-filter")
                                    schemes = list()
                                    mimes = list()
                                    hosts = list()
                                    paths = list()
                                    if intents:
                                        # Enumerate data schemes for the
                                        # intent filters
                                        for intent in intents:
                                            data = intent.getElementsByTagName("data")
                                            if data:
                                                for d in data:
                                                    if d.getAttribute("android:scheme"):
                                                        schemes.append(d.getAttribute("android:scheme"))
                                                    if d.getAttribute("android:mimeType"):
                                                        mimes.append(d.getAttribute("android:mimeType"))
                                                    if d.getAttribute("android:host"):
                                                        hosts.append(d.getAttribute("android:host"))
                                                    if d.getAttribute("android:path"):
                                                        paths.append(d.getAttribute("android:path"))
                                        schemes = list(set(schemes))
                                        mimes = list(set(mimes))
                                        hosts = list(set(hosts))
                                        paths = list(set(paths))
                                        for scheme in schemes:
                                            print(self.t.cyan("\t\t--> scheme : {}".format(scheme)))
                                        for mime in mimes:
                                            print(self.t.magenta("\t\t--> mime : {}".format(mime)))
                                        for host in hosts:
                                            print(self.t.white("\t\t--> host : {}".format(host)))
                                        for path in paths:
                                            print(self.t.white("\t\t--> path : {}".format(path)))
                                        print("\n")
                            elif activity.getAttribute("android:exported") == "false":
                                continue
                        else:
                            filters = self.apk.get_intent_filters("activity", a)
                            if filters:
                                # Enumerate the intent filter's action and category
                                # elements
                                print(self.t.yellow("\n\t--> activity : {}".format(a)))
                                if activity.getAttribute("android:permission"):
                                    print(self.t.red("\t\t--> permission : {}".format(activity.getAttribute("android:permission"))))
                                for key, values in filters.items():
                                    if key == "action":
                                        for value in values:
                                            print(self.t.yellow("\t\t--> action : {}".format(value)))
                                    if key == "category":
                                        for value in values:
                                            print(self.t.yellow("\t\t--> category : {}".format(value)))
                                # Pull data schemes from XML
                                intents = activity.getElementsByTagName("intent-filter")
                                schemes = list()
                                mimes = list()
                                hosts = list()
                                paths = list()
                                if intents:
                                    # Enumerate data schemes for the
                                    # intent filters
                                    for intent in intents:
                                        data = intent.getElementsByTagName("data")
                                        if data:
                                            for d in data:
                                                if d.getAttribute("android:scheme"):
                                                    schemes.append(d.getAttribute("android:scheme"))
                                                if d.getAttribute("android:mimeType"):
                                                    mimes.append(d.getAttribute("android:mimeType"))
                                                if d.getAttribute("android:host"):
                                                    hosts.append(d.getAttribute("android:host"))
                                                if d.getAttribute("android:path"):
                                                    paths.append(d.getAttribute("android:path"))
                                    schemes = list(set(schemes))
                                    mimes = list(set(mimes))
                                    hosts = list(set(hosts))
                                    paths = list(set(paths))
                                    for scheme in schemes:
                                        print(self.t.cyan("\t\t--> scheme : {}".format(scheme)))
                                    for mime in mimes:
                                        print(self.t.magenta("\t\t--> mime : {}".format(mime)))
                                    for host in hosts:
                                        print(self.t.white("\t\t--> host : {}".format(host)))
                                    for path in paths:
                                        print(self.t.white("\t\t--> path : {}".format(path)))
                                    print("\n")
            else:
                AttackSurfaceError("Activites not loaded from XML (!)")

    def receivers(self):
        """
        Analyze the attack surface for receivers
        """
        filters = None
        # TODO Enumerate the permission attribute for the activity element
        for r in self.components.receivers:
            if self.xml_receivers:
                for receiver in self.xml_receivers:
                    # Match the element name with the component name
                    if receiver.getAttribute("android:name") == r \
                            or receiver.getAttribute("android.name").split(".")[-1] == r.split(".")[-1]:
                        # Find the android:exported element attribute
                        if receiver.getAttribute("android:exported"):
                            # Determine if the attribute is set to true
                            if receiver.getAttribute("android:exported") == "true":
                                print(self.t.yellow("\n\t--> receiver : {}".format(r)))
                                if receiver.getAttribute("android:permission"):
                                    print(self.t.red("\t\t--> permission : {}".format(receiver.getAttribute("android:permission"))))
                                    # Enumerate the intent filters for the give receiver
                                filters = self.apk.get_intent_filters("receiver", r)
                                if filters:
                                    # Enumerate the intent filter's action and category
                                    # elements
                                    for key, values in filters.items():
                                        if key == "action":
                                            for value in values:
                                                print(self.t.yellow("\t\t--> action : {}".format(value)))
                                        if key == "category":
                                            for value in values:
                                                print(self.t.yellow("\t\t--> category : {}".format(value)))
                                    print("\n")
                            elif receiver.getAttribute("android:exported") == "false":
                                continue
                        else:
                            print(self.t.yellow("\n\t--> receiver : {}".format(r)))
                            if receiver.getAttribute("android:permission"):
                                print(self.t.red("\t\t--> permission : {}".format(receiver.getAttribute("android:permission"))))
                            filters = self.apk.get_intent_filters("receiver", r)
                            if filters:
                                # Enumerate the intent filter's action and category
                                # elements
                                for key, values in filters.items():
                                    if key == "action":
                                        for value in values:
                                            print(self.t.yellow("\t\t--> action : {}".format(value)))
                                    if key == "category":
                                        for value in values:
                                            print(self.t.yellow("\t\t--> category : {}".format(value)))
                                print("\n")
            else:
                AttackSurfaceError("Receivers not loaded from XML (!)")

    def services(self):
        """
        Analyze the attack surface for services
        """
        filters = None
        # TODO Enumerate the permission attribute for the service element
        for s in self.components.services:
            if self.xml_services:
                for service in self.xml_services:
                    # Match the element name with the component name
                    if service.getAttribute("android:name") == s \
                            or service.getAttribute("android.name").split(".")[-1] == s.split(".")[-1]:
                        # Find the android:exported element attribute
                        if service.getAttribute("android:exported"):
                            # Determine if the attribute is set to true
                            if service.getAttribute("android:exported") == "true":
                                print(self.t.yellow("\n\t--> service : {}".format(s)))
                                if service.getAttribute("android:permission"):
                                    print(self.t.red("\t\t--> permission : {}".format(service.getAttribute("android:permission"))))
                                    # Enumerate the intent filters for the give receiver
                                filters = self.apk.get_intent_filters("service", s)
                                if filters:
                                    # Enumerate the intent filter's action and category
                                    # elements
                                    for key, values in filters.items():
                                        if key == "action":
                                            for value in values:
                                                print(self.t.yellow("\t\t--> action : {}".format(value)))
                                    print("\n")
                            elif service.getAttribute("android:exported") == "false":
                                continue
                        else:
                            print(self.t.yellow("\n\t--> service : {}".format(s)))
                            if service.getAttribute("android:permission"):
                                print(self.t.red("\t\t--> permission : {}".format(service.getAttribute("android:permission"))))
                            filters = self.apk.get_intent_filters("service", s)
                            if filters:
                                # Enumerate the intent filter's action and category
                                # elements
                                for key, values in filters.items():
                                    if key == "action":
                                        for value in values:
                                            print(self.t.yellow("\t\t--> action : {}".format(value)))
                                print("\n")
            else:
                AttackSurfaceError("Services not loaded from XML (!)")

    def providers(self):
        """
        Analyze the attack surface for providers
        """
        filters = None
        # TODO Enumerate the permission attribute for the provider element
        for p in self.components.providers:
            if self.xml_providers:
                for provider in self.xml_providers:
                    # Match the element name with the component name
                    if provider.getAttribute("android:name") == p \
                            or provider.getAttribute("android.name").split(".")[-1] == p.split(".")[-1]:
                        # Find the android:exported element attribute
                        if provider.getAttribute("android:exported"):
                            # Determine if the attribute is set to true
                            if provider.getAttribute("android:exported") == "true":
                                print(self.t.yellow("\n\t--> provider : {}".format(p)))
                                if provider.getAttribute("android:permission"):
                                    print(self.t.red("\t\t--> provider : {}".format(provider.getAttribute("android:permission"))))
                            elif provider.getAttribute("android:exported") == "false":
                                continue
            else:
                AttackSurfaceError("Services not loaded from XML (!)")

    def run(self):
        """
        Discover application's attack surface
        """
        if self.components.activities:
            self.activities()
        if self.components.services:
            self.services()
        if self.components.receivers:
            self.receivers()
        if self.components.providers:
            self.providers()
