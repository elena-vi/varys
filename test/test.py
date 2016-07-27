import unittest

class MyTest(unittest.TestCase):
    def test1(self):
        self.assertEqual(2+2, 4)
    def test2(self):
        self.assertEqual(1+3, 4)
    def test3(self):
        self.assertEqual(0+4, 4)

if __name__ == "__main__":
		unittest.main()