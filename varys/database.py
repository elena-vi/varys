import psycopg2

class VarysDatabase(object):

	# def __init__(self):
	# 	print 'hey?'
	conn = psycopg2.connect("dbname=varys_development user=Elena")
	cur = conn.cursor()

	def connect(self):
		try:
			self.cur.execute("CREATE TABLE IF NOT EXISTS webpages (id serial PRIMARY KEY, url varchar, title varchar, description varchar);")
			self.conn.commit()
		except: 
			self.conn.rollback()
		pass

	def insert(self, url, title, description):
		try:
			sql = "INSERT INTO webpages (url, title, description) VALUES ('{url}', '{title}', '{description}')".format(url=url, title=title[0].encode('ascii',errors='ignore'), description=description[0].encode('ascii',errors='ignore'))
			self.cur.execute(sql)
			self.conn.commit()
		except: 
			self.conn.rollback()
		pass

	def close(self):
		self.cur.close()
		self.conn.close()