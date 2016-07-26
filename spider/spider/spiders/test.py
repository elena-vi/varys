from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector
# from craigslist_sample.items import CraigslistSampleItem


class MySpider(BaseSpider):
  name = "twitter"
  start_urls = ["https://twitter.com/"]

  def parse(self, response):
    hxs = HtmlXPathSelector(response)
    links = hxs.xpath("//a")
    collected_links = []
    for links in links:
      link = str(links.xpath("@href").extract())[3:-2]
      if link:
	      collected_links.append(link)
    print "\n -------- START LINKS --------"
    print collected_links
    print "\n --------- END LINKS ---------"