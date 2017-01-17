
class CryptoModel:
    values = {
        "javax.crypto.spec.DESKeySpec": [
            "<init>",
            "getKey"
        ],
        "javax.crypto.SecretKeyFactory": [
            "<init>",
            "generateSecret",
            "getAlgorithm",
            "getInstance",
            "getKeySpec",
            "getProvider"
        ]
    }


class CryptoModule(object):
    def __init__(self):
        self.name = "crypto"
        self.model = CryptoModel()
