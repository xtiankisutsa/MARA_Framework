
class SystemModel:
    values = {
        "java.lang.System": [
            "load",
            "loadLibrary"
        ]
    }


class SystemModule(object):
    def __init__(self):
        self.name = "system"
        self.model = SystemModel()
