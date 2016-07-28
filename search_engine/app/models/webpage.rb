class Webpage
  include DataMapper::Resource

  property :id, Serial
  property :title, String, length: 255, required: true
  property :description, String, length: 255, required: true
  property :url, String, length: 255, required: true
end
