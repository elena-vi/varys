# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html

import psycopg2
from database import VarysDatabase

class VarysPipeline(object):

	def open_spider(self, spider):
		print '-----------'
		print 'OPEN'
		print '-----------'
		VarysDatabase().connect()
		pass

	def process_item(self, item, spider):
		print '-----------'
		print 'PROCESS'
		print '-----------'
		VarysDatabase().insert(item["link"], item["title"], item["description"])
		return item

	def close_spider(self, spider):
		print '-----------'
		print 'CLOSE'
		print '-----------'
		VarysDatabase().close()
		pass


	# def connect(self):

	# def insert(self, url, title):

	# def close(self):
