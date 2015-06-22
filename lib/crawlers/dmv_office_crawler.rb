require 'JSON'
require 'nokogiri'
require 'rubygems'
require 'open-uri'

url = 'https://data.ny.gov/api/views/9upz-c7xg/rows.json?accessType=DOWNLOAD'
output = open(url) { |f| f.read }
json_data = JSON.parse(output)

json_data['data'].each do |office|
  phone = office[10]
  office_type = office[9]
  name = office[8]
  street_address = office[12]
  zip = office[16]
  city = office[14]
  state = office[15]
  monday = []
  monday.push(office[17], office[18])
  tuesday = []
  tuesday.push(office[19], office[20])
  wednesday = []
  wednesday.push(office[21], office[22])
  thursday = []
  thursday.push(office[23], office[24])
  friday = []
  friday.push(office[25], office[26])
  saturday = []
  saturday.push(office[27], office[28])
  hours = {}
  hours = { monday: monday, tuesday: tueday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday }
  
  puts ">> " + name
  puts street_address + ' ' + zip + ' ' + city + ' ' + state
  puts hours[monday].to_s
  puts hours[saturday].to_s
end