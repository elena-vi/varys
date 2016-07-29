import unittest
from urlParser import Parser

class UrlsTests(unittest.TestCase):

  def test_Remove_Query(self):
    url = 'http://www.bbc.co.uk/news/example.html?boring'
    noQuery = Parser(url).removeQuery()
    self.assertEqual(noQuery, 'http://www.bbc.co.uk/news/example.html')


if __name__ == '__main__':
  unittest.main()
