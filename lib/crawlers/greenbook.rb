require 'json'
require 'nokogiri'
require 'open-uri'

url = 'http://a856-gbol.nyc.gov/gbolwebsite/CityAgencies.aspx'

page = open(url) { |f| f.read }
nokopage = Nokogiri::HTML(page)

list_of_agencies = nokopage.css('.ahrefUnderline')

def get_links(list)
  names_and_links_of_agencies = [ ]
  greenbook_address = 'http://a856-gbol.nyc.gov/gbolwebsite/'
  list.each do |agency|
    agency_url_suffix = agency['href']
    agency_name = agency.text.strip
    agency_url = greenbook_address + agency_url_suffix
    names_and_links_of_agencies.push({name: agency_name, website: agency_url})
  end
  return names_and_links_of_agencies
end

puts get_links(list_of_agencies)

#for each page

page => pass to nokogiri

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
#there are 48 items in 'subordinates', 0 is info about the site, and 1 is the mayor himself

#scrape info about the incumbent chief of the agency - true for every page?
agency_chief_info = subordinates[1].css('tr').text.strip
dash_index = agency_chief_info.index('-')
salary_index = agency_chief_info.index('Salary')
agency_chief_name = agency_chief_info[dash_index+3..salary_index-3]
salary_start_index = agency_chief_info.index('$')
period_index = agency_chief_info.index('.')
salary = agency_chief_info[salary_start_index..period_index]
authority_source_info = agency_chief_info[period_index+2..-1]
if agency_chief_info.index('Elected') >= 0
  authority_source = 'Elected'
end
if agency_chief_info.index('Appointed') >= 0
  authority_sourve = 'Appointed'
end

#scrape info about 
subordinates[2..-1].each do |office|
  
  entity_name = office.css('a').text
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[2].text
  chief = office.css('tr')[3].text.strip
  dash_index = chief.index('-')
  chief_title = chief[0..dash_index-2]
  salary_string_index = chief.index('Salary')
  chief_name = chief[dash_index+3..salary_string_index-3]
  
  salary_start_index = office.css('tr')[3].index('$')
  salary = chief[salary_start_index..-1]
  deputy = office.css('tr')[4].text.strip

