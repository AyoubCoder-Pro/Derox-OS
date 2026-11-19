import copy
import json
import unittest
from pathlib import Path

from validate_iso_profile import validate

PROFILE = json.loads((Path(__file__).parents[1] / "build" / "iso-profile.json").read_text(encoding="utf-8"))

class IsoProfileTests(unittest.TestCase):
    def test_repository_profile_is_valid(self):
        self.assertEqual(validate(PROFILE), [])

    def test_rejects_missing_installer(self):
        data = copy.deepcopy(PROFILE)
        data["include"].remove("live-session-and-guided-installer")
        self.assertTrue(any("missing" in error for error in validate(data)))

    def test_rejects_excluding_storage_safety_component(self):
        data = copy.deepcopy(PROFILE)
        data["exclude"].append("storage-drivers-required-to-boot-and-install")
        self.assertTrue(any("never be excluded" in error for error in validate(data)))

    def test_rejects_non_squashfs_live_root(self):
        data = copy.deepcopy(PROFILE)
        data["compression"]["filesystem"] = "ext4"
        self.assertTrue(any("SquashFS" in error for error in validate(data)))

    def test_rejects_include_exclude_overlap(self):
        data = copy.deepcopy(PROFILE)
        data["exclude"].append(data["include"][0])
        self.assertTrue(any("both included and excluded" in error for error in validate(data)))

if __name__ == "__main__":
    unittest.main()
