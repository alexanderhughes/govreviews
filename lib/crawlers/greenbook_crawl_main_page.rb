require 'nokogiri'
require 'open-uri'

url = 'http://a856-gbol.nyc.gov/gbolwebsite/CityAgencies.aspx'

page = open(url) { |f| f.read }
nokopage = Nokogiri::HTML(page)

list_of_agencies = nokopage.css('.ahrefUnderline')

def get_links(list)
  agency_links = []
  greenbook_address = 'http://a856-gbol.nyc.gov/gbolwebsite/'
  list.each do |agency|
    agency_url_suffix = agency['href']
    agency_name = agency.text.strip
    agency_url = greenbook_address + agency_url_suffix
    agency_links.push(agency_url)
  end
  return agency_links
end

agency_links = get_links(list_of_agencies)
#returns an array of full greenbook url for each agency

all_agencies = [] #initiate array to push all agencies into

agency_links[1..-1] do |agency_link|
  agency_page = open(agency_link) { |f| f.read }
  nokofile = Nokogiri::HTML(agency_page)

  #scrape info about the main agency - true for every page
  entity_name = nokofile.title.strip
  #get address
  if nokofile.css('#ContentPlaceHolder1_lblAgencyAddress').children[0] != nil
    address = nokofile.css('#ContentPlaceHolder1_lblAgencyAddress').children[0].text.strip
  else
    address = nil
  end
  #get phone 
  if nokofile.css('#ContentPlaceHolder1_lblAgencyPhoneFax').text != nil &&
     nokofile.css('#ContentPlaceHolder1_lblAgencyPhoneFax').css('b').text.strip[0] == "("
    phone = nokofile.css('#ContentPlaceHolder1_lblAgencyPhoneFax').css('b').text.strip[0..13]
  else
    phone = '311'
  end
  #get website 
  if nokofile.css('#ContentPlaceHolder1_lblAgencyWebAddress').css('a')[0] != nil
    website = nokofile.css('#ContentPlaceHolder1_lblAgencyWebAddress').css('a')[0].attributes['href'].value
  else
    website = nil
  end
  # get email
  if nokofile.css('#ContentPlaceHolder1_lblAgencyEmail').text != nil
    email = nokofile.css('#ContentPlaceHolder1_lblAgencyEmail').text.strip
  else
    email = nil
  end
  # get mission
  if nokofile.css('#ContentPlaceHolder1_lblMission').text != nil
    mission = nokofile.css('#ContentPlaceHolder1_lblMission').text
  else
    mission = nil
  end
  #get longer description
  if nokofile.css('.style3')[1].text != nil
    des = nokofile.css('.style3')[1].text.strip
  else
    des = nil
  end
  if mission != nil && des != nil
    description = mission.to_s + ' ' + des.to_s
  elsif mission != nil && des == nil
    description = mission
  elsif mission == nil && des != nil
    description = des
  elsif mission == nil && des == nil
    description = nil
  end
  
  results = { }
  results = { name: entity_name, address: address, phone: phone, website: website, email: email, description: description }
  all_agencies.push(results)
end

#create Public Entity for each item on the main page
all_agencies.each do |agency|
  mayor = PublicEntity.find_by(name: "Mayor, Office of the (OTM)")
  new_agency = PublicEntity.create(name: agency[:name], authority_level: 'city', address: agency[:address], phone: agency[:phone], description: agency[:description], entity_type: 'agency', website: agency[:website], superior: mayor)
end