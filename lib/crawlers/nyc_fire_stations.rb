require 'open-uri'
require 'json'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
url = 'https://nycopendata.socrata.com/Public-Safety/FDNY-Firehouse-Listing/hc8x-tcnd'
page = open(url) { |f| f.read }
output = JSON.parse(page)
data = output['data']

all_stations = []

data[1..-1].each do |fire_station|
  name = fire_station[8] + " Fire Station"
  street = fire_station[9]
  borrough = fire_station[10]
  address = street + ', ' + borrough + ', ' + 'New York'
  station = {}
  station = {name: name, address: address }
  all_stations.push(station)
end  
  
all_stations.each do |station|
  fdny = PublicEntity.find_by(name: "Fire Department, New York City (FDNY)")
  c = Category.find_or_create_by(name: "Fire Station")
  fire_station = PublicEntity.create(name: station[:name], address: station[:address], authority_level = 'city', description = 'Fire Station.', website = 'www.nyc.gov/fdny', entity_type = 'Fire Station', source = 'NYCOpenData', source_accessed = Time.now, superior: fdny )
  fire_station.categories.push(c)
end