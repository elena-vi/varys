class Database

	require 'pg'

	attr_reader :connection
	def self.search(query_string)
		begin
			connection = PG.connect :dbname => 'varys_' + ENV['RACK_ENV']
			results = connection.exec "SELECT DISTINCT id, title, description, url, ts_rank_cd(textsearch, query) AS rank
			FROM webpages, plainto_tsquery('english', '#{query_string}') query, to_tsvector(url || title || description) textsearch
			WHERE query @@ textsearch
			ORDER BY rank DESC"
			# LIMIT 10 OFFSET #{query_from}
		rescue PG::Error => e
			puts e.message
			results = []
		ensure
			connection.close if connection
		end
		results
	end

	def self.insert_webpage(title, description, url, clicks)
		begin
			connection = open_connection
			connection.exec "INSERT INTO webpages (title, description, url, clicks) VALUES('#{title}','#{description}','#{url}', '#{clicks}');"
		rescue PG::Error => e
			puts e.message
		ensure
			connection.close if connection
		end
	end

	def self.get_id(title, description, url)
		begin
			connection = open_connection
			id = connection.exec "SELECT id FROM webpages WHERE title = '#{title}' AND description = '#{description}' AND url = '#{url}'"
		rescue PG::Error => e
			puts e.message
		ensure
			connection.close if connection
		end
		id.values.last[0].to_i
	end

	def self.get_by_id(id)
		begin
			connection = open_connection
			result = connection.exec "SELECT id, title, description, url, clicks FROM webpages WHERE id=#{id}"
		rescue PG::Error => e
			puts e.message
			result = []
		ensure
			connection.close if connection
		end
		result
	end


	private

	def self.open_connection
		PG.connect :dbname => 'varys_' + ENV['RACK_ENV']
	end


end












