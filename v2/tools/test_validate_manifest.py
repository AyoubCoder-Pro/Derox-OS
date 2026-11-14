import hashlib
import unittest

from validate_manifest import validate


class ManifestValidationTests(unittest.TestCase):
    def setUp(self):
        self.manifest = {
            "schema_version": 1,
            "name": "demo-app",
            "version": "1.0.0",
            "architecture": "x86_64",
            "description": "Example package",
            "license": "MIT",
            "dependencies": [],
            "conflicts": [],
            "payload": {
                "file": "demo-app-1.0.0.tar.zst",
                "format": "tar.zst",
                "sha256": hashlib.sha256(b"payload").hexdigest(),
            },
        }

    def test_valid_manifest(self):
        self.assertEqual(validate(self.manifest), [])

    def test_rejects_path_traversal(self):
        self.manifest["payload"]["file"] = "../payload.tar.zst"
        self.assertTrue(any("safe filename" in e for e in validate(self.manifest)))

    def test_rejects_invalid_digest(self):
        self.manifest["payload"]["sha256"] = "not-a-hash"
        self.assertTrue(any("64 hexadecimal" in e for e in validate(self.manifest)))

    def test_rejects_duplicate_dependencies(self):
        self.manifest["dependencies"] = ["lib-a", "lib-a"]
        self.assertTrue(any("duplicates" in e for e in validate(self.manifest)))


if __name__ == "__main__":
    unittest.main()
