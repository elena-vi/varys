import unittest
from varys.src.urlParser import Parser

class UrlsTests(unittest.TestCase):

  def test_Remove_Query(self):
    url = 'http://www.bbc.co.uk/news/example.html?boring'
    noQuery = Parser(url).removeQuery()
    self.assertEqual(noQuery, 'http://www.bbc.co.uk/news/example.html')
  
  def test_Join_Path(self):
    domain = 'http://www.bbc.co.uk'
    path = '/sport/tennis/silly.htm'
    joined = Parser(path).joinDomain(domain)
    self.assertEqual(joined, 'http://www.bbc.co.uk/sport/tennis/silly.htm')

  def test_Join_Path2(self):
    domain = 'http://www.bbc.co.uk'
    path = 'http://wrong.com/sport/tennis/silly.htm'
    joined = Parser(path).joinDomain(domain)
    self.assertEqual(joined, 'http://www.bbc.co.uk/sport/tennis/silly.htm')

  def test_Join_Path3(self):
    domain = 'http://www.bbc.co.uk/wrong_path?bad=query#silly_frag'
    path = '/sport/tennis/silly.htm'
    joined = Parser(path).joinDomain(domain)
    self.assertEqual(joined, 'http://www.bbc.co.uk/sport/tennis/silly.htm')

if __name__ == '__main__':
  unittest.main()
