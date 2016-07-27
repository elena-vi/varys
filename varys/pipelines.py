# -*- coding: utf-8 -*-

# Define your item pipelines here
#
# Don't forget to add your pipeline to the ITEM_PIPELINES setting
# See: http://doc.scrapy.org/en/latest/topics/item-pipeline.html
import rethinkdb as r


class VarysPipeline(object):

	def open_spider(self, spider):
		r.connect('localhost', 28015).repl()

	def process_item(self, item, spider):
		r.db('items').table('links').insert({ 'url': item["link"], 'title': item["title"]}).run()
		return item