import unittest

class TestClassWithFailingClassSetUp(unittest.TestCase):

    @classmethod
    def setUpClass(cls):
        assert False

    def test_something(self):
        pass

    def test_something_else(self):
        pass


class TestClassWithFailingClassTearDown(unittest.TestCase):

    @classmethod
    def tearDownClass(cls):
        assert False

    def test_something(self):
        pass

    def test_something_else(self):
        pass

class TestClassWithFailingTestTearDown(unittest.TestCase):

    def setUp(self):
        pass

    def tearDown(self):
        assert False

    def test_something(self):
        pass


#@unittest.skip("demonstrating skipping")

#@unittest.skipIf(mylib.__version__ < (1, 3), "not supported in this library version")

#@unittest.skipUnless(sys.platform.startswith("win"), "requires Windows")

# @unittest.skip("showing class skipping")
# class MySkippedTestCase(unittest.TestCase):
