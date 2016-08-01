from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors.sgml import SgmlLinkExtractor
from scrapy.selector import HtmlXPathSelector
from scrapy import Request
from varys.items import VarysItem

from varys.src.urlParser import Parser

class CrawlSpider(CrawlSpider):
    name = "varys"
    allowed_domains = ["bbc.co.uk"]
    start_urls = (
        'http://news.bbc.co.uk/',
    )
    
    
    def parse(self, response):
      for newRequest in self.newRequests(response):
          yield newRequest
      for newItem in self.newItems(response):
          yield newItem

    def newRequests(self, response):
      array = []
      for link in response.xpath('//a/@href').extract():
        parsed = Parser(link).joinDomain(response.url)
        if (parsed.approved):
          array.append( Request(parsed.fullUrl(), callback=self.parse) )
      return array

    def newItems(self, response):
      array = []
      item = VarysItem()
      item["link"] = response.url
      item["title"] = response.xpath("//title/text()").extract()
      array.append(item)
      return array
