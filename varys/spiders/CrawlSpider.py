from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors.sgml import SgmlLinkExtractor
from scrapy.selector import HtmlXPathSelector
from varys.items import VarysItem

from varys.src.urlParser import Parser

class CrawlSpider(CrawlSpider):
    name = "varys"
    start_urls = ["http://makersacademy.com"]

    rules = (
        Rule(SgmlLinkExtractor(allow=(), restrict_xpaths=('//a',)), callback="parse_items", follow= True),
    )

    def parse_items(self, response):
        hxs = HtmlXPathSelector(response)
        item = VarysItem()
        item["link"] = response.url
        item["title"] = response.xpath("//title/text()").extract()
        return(item)
