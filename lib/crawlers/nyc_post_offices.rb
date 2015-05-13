desc "Crawl NY State Parks and load them into PublicEntity table"
task crawl_parks: :environment do
require 'json'
require 'open-uri'

url = 'https://data.cityofnewyork.us/api/views/bdha-6eqy/rows.json?accessType=DOWNLOAD'
file = open(url) { |f| f.read }
output = JSON.parse(file)
page = output["data"]

all_results = []

page.each do |office|
  name = office[9] + ' ' + 'Post Office'
  description = "Post Office"
  website = "http://www.usps.com"
  results = { name: name, description: description, website: website, authority_level: 'federal', entity_type: 'post_office' }
  all_results.push(results)
end

c = Category.create(name: 'Post Office')

all_results.each do |entity|
  pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type])
  pe.categories.push(c)
end
end