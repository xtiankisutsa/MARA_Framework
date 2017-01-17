
class ZipModel:
    values = {
        "java.util.zip.ZipFile": [
            "entries",
            "getEntry",
            "getInputStream",
            "getName"
        ],
        "java.util.zip.ZipInputStream": [
            "getNextEntry",
            "read",
        ],
        "java.util.zip.ZipEntry": [
            "getName",
            "isDirectory",
        ]
    }


class ZipModule(object):
    def __init__(self):
        self.name = "zip"
        self.model = ZipModel()
