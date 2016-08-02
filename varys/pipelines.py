# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
from scrapy.exceptions import DropItem
import psycopg2
from database import VarysDatabase

class VarysPipeline(object):

	def open_spider(self, spider):
		# open database connection
		VarysDatabase().connect()
		pass

	def process_item(self, item, spider):
		if len(item["link"]) <= 500:
			VarysDatabase().insert(item["link"], item["title"], item["description"])
			return item
		else:
			raise DropItem("URL TOO LONG")

	def close_spider(self, spider):
		# Close database connection
		VarysDatabase().close()
		pass