import scrapy
from scrapy.crawler import CrawlerProcess
from scrapy.spider import BaseSpider
from scrapy.selector import HtmlXPathSelector

class Varys(BaseSpider):
  name = "spider"
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
# process = CrawlerProcess()
# process.crawl(twitter)
# process.start() 