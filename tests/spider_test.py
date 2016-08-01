import unittest
from varys.spiders.CrawlSpider import CrawlSpider 
from scrapy.http.request import Request



class Tests(unittest.TestCase):

  def test_newRequests(self):
    requests = CrawlSpider().newRequests(ResponseStub())
    self.assertEqual(requests[0].url, 'http://www.foundlink.com/found_eath')

  def test_newItems(self):
    items = CrawlSpider().newItems(ResponseStub())
    self.assertEqual(items[0]["link"], 'http://scrapedpage.com/')

class ResponseStub():
  url = 'http://scrapedpage.com/'
  def xpath(self, string):
    return self
  def extract(self):
    return ['http://www.foundlink.com/found_path']



if __name__ == '__main__':
  unittest.main()
