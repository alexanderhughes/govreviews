require 'json'
require 'nokogiri'
require 'open-uri'

url = 'http://a856-gbol.nyc.gov/gbolwebsite/CityAgencies.aspx'

page = open(url) { |f| f.read }
nokopage = Nokogiri::HTML(page)

list_of_agencies = nokopage.css('.ahrefUnderline')

def get_links(list)
  names_and_links_of_agencies = {}
  greenbook_address = 'http://a856-gbol.nyc.gov/gbolwebsite/'
  list.each do |agency|
    agency_url_suffix = agency['href']
    agency_name = agency.text.strip
    agency_url = greenbook_address + agency_url_suffix
    names_and_links_of_agencies[agency_name] = agency_url
  end
  return names_and_links_of_agencies
end

names_and_links_of_agencies = get_links(list_of_agencies)
#returns a dictionary of agency name, full greenbook url

#Mayor, Office of the (OTM)
mayor_page = names_and_links_of_agencies['Mayor, Office of the (OTM)']
mayor_page = open(mayor_page) { |f| f.read }
nokofile = Nokogiri::HTML(mayor_page)

#scrape info about the main agency - true for every page
entity_name = nokofile.title.strip
address = nokofile.css('#ContentPlaceHolder1_lblAgencyAddress').text
phone = nokofile.css('#ContentPlaceHolder1_lblAgencyPhoneFax').text
website = nokofile.css('#ContentPlaceHolder1_lblAgencyWebAddress').css('a')[0].attributes['href'].value
email = nokofile.css('#ContentPlaceHolder1_lblAgencyEmail').text
mission = nokofile.css('#ContentPlaceHolder1_lblMission').text
des = nokofile.css('.style3')[1].text.strip
full_description = mission + ' ' + des

subordinates = nokofile.css('table')
#there are 48 items in 'subordinates', 0 is info about the site, and 1 is the mayor himself. 47 is page info.

#scrape info about the incumbent chief of the agency - true for every page?
agency_chief_info = subordinates[1].css('tr').text.strip
dash_index = agency_chief_info.index('-')
salary_index = agency_chief_info.index('Salary')
agency_chief_name = agency_chief_info[dash_index+3..salary_index-3]
salary_start_index = agency_chief_info.index('$')
period_index = agency_chief_info.index('.')
salary = agency_chief_info[salary_start_index..period_index]
authority_source_info = agency_chief_info[period_index+2..-1]
if agency_chief_info.index('Elected') != nil
  authority_source = 'Elected'
end
if agency_chief_info.index('Appointed') != nil
  authority_sourve = 'Appointed'
end

subordinates[2..46].each do |office|
  
  entity_info = []
  if office.css('a')[0] != nil
    entity_name = office.css('a')[0].text.strip
  else
    break
  end
  
  entity_info.push(entity_name)
  #check for website
  if office.css('a')[1] != nil && office.css('a')[1].text.index('.gov') != nil
    website = office.css('a')[1].text.strip
    entity_info.push(website)
  end
  
  
  #check for address, phone, description
  n = 0
  while office.css('tr')[n] != nil
    if office.css('tr')[n].text.index('New York, NY') != nil
      address = office.css('tr')[n].text.strip
      entity_info.push(address)
    end
    if office.css('tr')[n].text.strip[0] == '('
      phone = office.css('tr')[n].text.strip
      entity_info.push(phone)
    end
    if office.css('tr')[n].text.strip.length >= 100
      description = office.css('tr').text.strip
      entity_info.push(description)
    end
    n += 1
  end
  
  puts entity_info
end
  
  