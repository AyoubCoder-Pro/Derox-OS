import tempfile
import unittest
from pathlib import Path

from check_independence import scan_tree


class IndependenceTests(unittest.TestCase):
    def test_clean_source_build_tree_passes(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "v2" / "build").mkdir(parents=True)
            (root / "v2" / "build" / "build.sh").write_text(
                "#!/bin/sh\nmake all\n", encoding="utf-8"
            )
            self.assertEqual(scan_tree(root), [])

    def test_debian_package_command_is_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "v2" / "build").mkdir(parents=True)
            (root / "v2" / "build" / "build.sh").write_text(
                "#!/bin/sh\napt-get install example\n", encoding="utf-8"
            )
            self.assertTrue(any("Debian package/build command" in x for x in scan_tree(root)))

    def test_debian_runtime_marker_is_rejected(self):
        with tempfile.TemporaryDirectory() as tmp:
            root = Path(tmp)
            (root / "iso").mkdir()
            (root / "iso" / "image.cfg").write_text(
                "release_file=/etc/debian_version\n", encoding="utf-8"
            )
            self.assertTrue(any("Debian release marker" in x for x in scan_tree(root)))


if __name__ == "__main__":
    unittest.main()
