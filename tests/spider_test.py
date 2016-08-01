import unittest
from scrapy.http import Request, Response

from varys.spiders.CrawlSpider import CrawlSpider 
from varys.items import VarysItem 

class ResponseMock():
  url = 'http://scrapedpage.com/'
  def xpath(self, string):
    return self
  def extract(self):
    return ['http://www.foundlink.com/found_path']

'''
def fake_response_from_file(file_name, url=None):
    if not url:
        url = 'http://www.example.com'

    request = Request(url=url)
    if not file_name[0] == '/':
        responses_dir = os.path.dirname(os.path.realpath(__file__))
        file_path = os.path.join(responses_dir, file_name)
    else:
        file_path = file_name

    file_content = open(file_path, 'r').read()

    response = Response(url=url,
        request=request,
        body=file_content)
    response.encoding = 'utf-8'
    return response
'''

class SpiderTests(unittest.TestCase):

  def test_parse(self):
    results = CrawlSpider().parse(ResponseMock())
    for result in results:
      self.assertTrue((type(result) == Request) or (type(result) == VarysItem))

  def test_newRequests(self):
    requests = CrawlSpider().newRequests(ResponseMock())
    self.assertEqual(requests[0].url, 'http://www.foundlink.com/found_path')

  def test_newItems(self):
    items = CrawlSpider().newItems(ResponseMock())
    self.assertEqual(items[0]["link"], 'http://scrapedpage.com/')



if __name__ == '__main__':
  unittest.main()
