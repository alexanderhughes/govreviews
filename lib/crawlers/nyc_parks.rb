desc "Crawl NY State Parks and load them into PublicEntity table"
task crawl_parks: :environment do
require 'json'
require 'open-uri'

url = 'https://data.cityofnewyork.us/api/views/y6ja-fw4f/rows.json?accessType=DOWNLOAD'
file = open(url) { |f| f.read }
output = JSON.parse(file)
output_parsed = JSON.parse(output)
page = output_parse["data"]

page.each do |park|
  name = park[8] + ' ' + park[9]
  description = park[9]
  website = park[17][0]
  results = { name: name, description: description, website: website, authority_level: 'state', entity_type: 'park' }
  all_results.push(results)
end

c = Category.create(name: 'Park')

all_results.each do |entity|
  pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type])
  pe.categories.push(c)
end
end