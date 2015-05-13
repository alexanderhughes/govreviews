require 'json'
require 'open-uri'

url = 'https://data.cityofnewyork.us/api/views/kk4q-3rt2/rows.json?accessType=DOWNLOAD'
page = open(url) { |f| f.read }
output = JSON.parse(page)
info = output["data"]

all_results = []

info.each do |station|
  name = station[9]
  description = "Subway station servicing lines" + " " + station[10]
  website = station[8]
  results = {}
  results = { name: name, description: description, website: website, authority_level: "city", entity_type: "subway_station", category: ["Transportation", "Subway Stations"] }
  all_results.push(results)
end

all_results.each do |entity|
  pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type])
  entity[:category].each do |catg|
    c = Category.find_or_create_by(name: catg)
    pe.categories.push(c)
  end
end
