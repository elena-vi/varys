FactoryGirl.define do
  factory :webpage, class: Webpage do
  	id "1"
    title 'Portsmouth News: The News'
    description 'news, sport, business, lifestyle and more,
                 from newspaper from Portsmouth, The News.'
    url 'http://www.portsmouth.co.uk'

    initialize_with { new(:id =>  id, :title => title, :description =>  description, :url =>  url) }
  end
end
