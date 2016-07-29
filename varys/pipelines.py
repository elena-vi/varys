# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import rethinkdb as r
from database import VarysDatabase


class VarysPipeline(object):

	def open_spider(self, spider):
		VarysDatabase().connect()
		pass

	def process_item(self, item, spider):
		# VarysDatabase().hey("yes")
		# r.db('items').table('links').insert({ 'url': item["link"], 'title': item["title"]}).run()
		return item

	def close_spider(self, spider):
		print '-----------------'
		print 'close_spider'
		print '-----------------'

		pass