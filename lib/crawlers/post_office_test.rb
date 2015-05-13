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

puts all_results[0]