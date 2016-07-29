import psycopg2

class VarysDatabase(object):

	# def __init__(self):
	# 	print 'hey?'

	def connect(self):
		print r.connect('localhost', 28015).repl()
		print r.dbList()

		pass

	def insert(self, url, title):
		r.connect('localhost', 28015).repl()
		pass


from database import VarysDatabase
VarysDatabase().connect()