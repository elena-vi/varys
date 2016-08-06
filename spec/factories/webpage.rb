FactoryGirl.define do
  factory :webpage, class: Webpage do
    title 'Portsmouth News: The News'
    description 'news, sport, business, lifestyle and more, from newspaper from Portsmouth, The News.'
    url 'http://www.portsmouth.co.uk/'
    clicks 0

    initialize_with { new(title: title, description: description, url: url, clicks: clicks) }
  end
end
