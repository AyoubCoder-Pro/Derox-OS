import unittest
from validate_sources import validate
class SourceLockValidationTests(unittest.TestCase):
    def setUp(self):
        self.lock={"schema_version":1,"distribution":"DEROX OS","release_track":"2.0-development","architecture":"x86_64","sources":[{"name":"example","version":"1.2.3","url":"https://example.org/example-1.2.3.tar.xz","archive":"example-1.2.3.tar.xz","sha256":"a"*64,"sha256_reference":"https://example.org/checksums.txt","sha256_provenance":"upstream-published","license":"MIT","homepage":"https://example.org"}]}
    def test_valid_lock(self): self.assertEqual(validate(self.lock),[])
    def test_rejects_missing_checksum(self):
        del self.lock["sources"][0]["sha256"]; self.assertTrue(any("sha256" in e for e in validate(self.lock)))
    def test_rejects_missing_provenance(self):
        del self.lock["sources"][0]["sha256_reference"]; self.assertTrue(any("sha256_reference" in e for e in validate(self.lock)))
    def test_rejects_local_only_digest(self):
        self.lock["sources"][0]["sha256_provenance"]="locally-computed"; self.assertTrue(any("sha256_provenance" in e for e in validate(self.lock)))
    def test_rejects_http_source(self):
        self.lock["sources"][0]["url"]="http://example.org/a.tar.xz"; self.assertTrue(any(".url must be an HTTPS URL" in e for e in validate(self.lock)))
    def test_rejects_duplicate_names(self):
        self.lock["sources"].append(dict(self.lock["sources"][0])); self.assertTrue(any("duplicates" in e for e in validate(self.lock)))
if __name__=="__main__": unittest.main()
