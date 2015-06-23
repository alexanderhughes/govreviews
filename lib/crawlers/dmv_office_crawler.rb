require 'JSON'
require 'rubygems'
require 'open-uri'
require 'openssl'

OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
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
  if office[17] !~ /[^[:space:]]/
    monday = nil
  else
    monday.push(office[17], office[18])
  end
  tuesday = []
  if office[19] !~ /[^[:space:]]/
    tuesday = nil
  else
    tuesday.push(office[19], office[20])
  end
  wednesday = []
  if office[21] !~ /[^[:space:]]/
    wednesday = nil
  else
    wednesday.push(office[21], office[22])
  end
  thursday = []
  if office[23] !~ /[^[:space:]]/
    thursday = nil
  else
    thursday.push(office[23], office[24])
  end
  friday = []
  if office[25] !~ /[^[:space:]]/
    fiday = nil
  else 
    friday.push(office[25], office[26])
  end
  saturday = []
  if office[27] !~ /[^[:space:]]/
    saturday = nil
  else
    saturday.push(office[27], office[28])
  end
  hours = {}
  hours = { monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday }
  
  puts ">> " + name
  puts street_address + ' ' + zip + ' ' + city + ' ' + state
  puts hours[:monday].to_s
  puts hours[:saturday].to_s
end