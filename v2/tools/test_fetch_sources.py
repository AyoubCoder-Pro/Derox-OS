import hashlib
import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

from fetch_sources import FetchError, download_one, safe_source_entry


class FakeResponse:
    def __init__(self, payload, final_url="https://example.org/archive.tar.xz"):
        self.payload = payload
        self.offset = 0
        self.final_url = final_url

    def __enter__(self):
        return self

    def __exit__(self, *args):
        return False

    def geturl(self):
        return self.final_url

    def read(self, size):
        chunk = self.payload[self.offset:self.offset + size]
        self.offset += len(chunk)
        return chunk


class FetchSourcesTests(unittest.TestCase):
    def test_accepts_valid_source(self):
        entry = {
            "name": "demo", "url": "https://example.org/demo.tar.xz",
            "archive": "demo.tar.xz", "sha256": "a" * 64,
        }
        self.assertEqual(safe_source_entry(entry, 0)[1], "demo.tar.xz")

    def test_rejects_path_traversal(self):
        entry = {
            "name": "demo", "url": "https://example.org/demo",
            "archive": "../demo", "sha256": "a" * 64,
        }
        with self.assertRaises(FetchError):
            safe_source_entry(entry, 0)

    def test_download_verifies_digest(self):
        payload = b"DEROX test archive"
        expected = hashlib.sha256(payload).hexdigest()
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "demo.tar.xz"
            with patch("fetch_sources.urllib.request.urlopen",
                       return_value=FakeResponse(payload)):
                download_one("https://example.org/archive.tar.xz", target, expected)
            self.assertEqual(target.read_bytes(), payload)
            self.assertFalse(target.with_name(target.name + ".part").exists())

    def test_bad_digest_does_not_leave_archive(self):
        payload = b"not the expected archive"
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "demo.tar.xz"
            with patch("fetch_sources.urllib.request.urlopen",
                       return_value=FakeResponse(payload)):
                with self.assertRaises(FetchError):
                    download_one("https://example.org/archive.tar.xz", target, "0" * 64)
            self.assertFalse(target.exists())
            self.assertFalse(target.with_name(target.name + ".part").exists())

    def test_rejects_https_downgrade_redirect(self):
        payload = b"archive"
        expected = hashlib.sha256(payload).hexdigest()
        with tempfile.TemporaryDirectory() as directory:
            target = Path(directory) / "demo.tar.xz"
            with patch("fetch_sources.urllib.request.urlopen",
                       return_value=FakeResponse(payload, "http://example.org/archive")):
                with self.assertRaises(FetchError):
                    download_one("https://example.org/archive", target, expected)
            self.assertFalse(target.exists())


if __name__ == "__main__":
    unittest.main()
