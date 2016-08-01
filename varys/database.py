import psycopg2

class VarysDatabase(object):

	# def __init__(self):
	# 	print 'hey?'
	conn = psycopg2.connect("dbname=varys_development user=Elena")
	cur = conn.cursor()

	def connect(self):
		self.cur.execute("CREATE TABLE IF NOT EXISTS test (id serial PRIMARY KEY, url varchar, title varchar);")
		self.conn.commit()
		pass

	def insert(self, url, title):
		sql = "INSERT INTO test (url, title) VALUES ('{url}', '{title}')".format(url=url, title=title[0].encode('ascii',errors='ignore'))
		self.cur.execute(sql)
		self.conn.commit()
		pass

	def close(self):
		self.cur.close()
		self.conn.close()