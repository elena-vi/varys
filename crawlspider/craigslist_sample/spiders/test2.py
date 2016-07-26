from scrapy.contrib.spiders import CrawlSpider, Rule
from scrapy.contrib.linkextractors.sgml import SgmlLinkExtractor
from scrapy.selector import HtmlXPathSelector
from craigslist_sample.items import CraigslistSampleItem


class MySpider(CrawlSpider):
    name = "craigs"
    start_urls = ["https://bbc.co.uk/"]

    rules = (
        Rule(SgmlLinkExtractor(allow=(), restrict_xpaths=('//a',)), callback="parse_items", follow= True),
    )

    def parse_items(self, response):
        hxs = HtmlXPathSelector(response)
        item = CraigslistSampleItem()
        item["link"] = response.url
        item["title"] = response.xpath("//title").extract()
        return(item)