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

chiefs = []
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

chiefs.push(agency_chief_name)
sub_chiefs = []

#scrape info about subordinates from First Deputy Mayor to Office of Intergovernmental Affairs
subordinates[2..10].each do |office|
  
  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[2].text
  chief_full = office.css('tr')[3].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[3].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  
  #chief2
  if office.css('tr')[4] != nil
    deputy_full = office.css('tr')[4].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name.to_s + ' ' + chief_name.to_s + ' ' + salary.to_s + ' ' + deputy_name.to_s
  
end

#scrape info from Office of City Legislative Affairs to NYC Federal Affairs Office
subordinates[11..13].each do |office|
  
  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[3].text
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[4].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  
  #chief2
  if office.css('tr')[5] != nil
    deputy_full = office.css('tr')[5].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name.to_s + ' ' + chief_name.to_s + ' ' + salary.to_s + ' ' + deputy_name.to_s
  
end

#scrape Mayor's community affairs unit
office = subordinates[14]
  
  entity_name = office.css('a')[0].text.strip
  website = office.css('a')[1].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[4].text
  chief_full = office.css('tr')[5].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[5].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  
  #chief2
  if office.css('tr')[6] != nil
    deputy_full = office.css('tr')[6].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
  

#scrape Mayor's Office for Strategic Partnerships
office = subordinates[15]

  entity_name = office.css('a')[0].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[2].text
  chief_full = office.css('tr')[3].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[3].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  
#scrape Mayor's Fund to Advance NY - subordinate of 15
office = subordinates[16]
  entity_name = office.css('a')[0].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  website = office.css('tr')[2].text.strip
  description = office.css('tr')[3].text.strip
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..-1]
  
  #chief2
  if office.css('tr')[5] != nil
    deputy_full = office.css('tr')[5].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name

#scrape Mayor's Office of Operations
office = subordinates[17]
  
  entity_name = office.css('a')[0].text.strip
  website = office.css('a')[1].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[4].text
  chief_full = office.css('tr')[5].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[5].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  
  #chief2
  if office.css('tr')[6] != nil
    deputy_full = office.css('tr')[6].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  
  #chief3
  if office.css('tr')[7] != nil
    deputy_full = office.css('tr')[7].text.strip
    deputy_dash_index = deputy_full.index('-')
    chief3_title = deputy_full[0..deputy_dash_index-2]
    chief3_name = deputy_full[deputy_dash_index+3..-1]
  end
  
  #chief4
  if office.css('tr')[8] != nil
    deputy_full = office.css('tr')[8].text.strip
    deputy_dash_index = deputy_full.index('-')
    chief4_title = deputy_full[0..deputy_dash_index-2]
    chief4_name = deputy_full[deputy_dash_index+3..-1]
  end
  
  #chief5
  if office.css('tr')[9] != nil
    deputy_full = office.css('tr')[9].text.strip
    deputy_dash_index = deputy_full.index('-')
    chief5_title = deputy_full[0..deputy_dash_index-2]
    cheif5_name = deputy_full[deputy_dash_index+3..-1]
  end
  
  #chief6
  if office.css('tr')[10] != nil
    deputy_full = office.css('tr')[10].text.strip
    deputy_dash_index = deputy_full.index('-')
    chief6_title = deputy_full[0..deputy_dash_index-2]
    chief6_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
  
#scrape Mayor's Office of Contract Services
office = subordinates[18]
  
  entity_name = office.css('a')[0].text.strip
  website = office.css('a')[1].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[4].text
  chief_full = office.css('tr')[5].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[5].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  
  #chief2
  if office.css('tr')[6] != nil
    deputy_full = office.css('tr')[6].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name

#scrape Mayor's Office of Contract Services
office = subordinates[19]
  
  entity_name = office.css('a')[0].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[2].text
  chief_full = office.css('tr')[3].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[3].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
  
  ################

office = subordinates[20]

  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[2].text
  chief_full = office.css('tr')[3].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[3].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]

  #chief2
  if office.css('tr')[4] != nil
    deputy_full = office.css('tr')[4].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
  
  ###################
  
office = subordinates[21]

  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  website = office.css('tr')[2].text.strip
  description = office.css('tr')[3].text
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[4].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]

  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
  
  #######################

office = subordinates[22]

  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  website = office.css('tr')[2].text.strip
  description = office.css('tr')[3].text
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[4].text.strip.index('$')
  if salary_start_index != nil
    salary = chief_full[salary_start_index..-1]
  end

  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
  

subordinates[23..24].each do |office|

  entity_name = office.css('a')[0].text.strip
  website = office.css('a')[1].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[4].text
  chief_full = office.css('tr')[5].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[5].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  
  #chief2
  if office.css('tr')[6] != nil
    deputy_full = office.css('tr')[6].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
end

office = subordinates[25]
  entity_name = office.css('a')[0].text.strip
  website = office.css('a')[1].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[4].text
  chief_full = office.css('tr')[5].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[5].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]

  #chief2
  if office.css('tr')[6] != nil
    deputy_full = office.css('tr')[6].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end

  #chief3
  if office.css('tr')[7] != nil
    deputy_full = office.css('tr')[7].text.strip
    deputy_dash_index = deputy_full.index('-')
    chief3_title = deputy_full[0..deputy_dash_index-2]
    chief3_name = deputy_full[deputy_dash_index+3..-1]
  end

  #chief4
  if office.css('tr')[8] != nil
    deputy_full = office.css('tr')[8].text.strip
    deputy_dash_index = deputy_full.index('-')
    chief4_title = deputy_full[0..deputy_dash_index-2]
    chief4_name = deputy_full[deputy_dash_index+3..-1]
  end

  #chief5
  if office.css('tr')[9] != nil
    deputy_full = office.css('tr')[9].text.strip
    deputy_dash_index = deputy_full.index('-')
    chief5_title = deputy_full[0..deputy_dash_index-2]
    cheif5_name = deputy_full[deputy_dash_index+3..-1]
  end

  #chief6
  if office.css('tr')[10] != nil
    deputy_full = office.css('tr')[10].text.strip
    deputy_dash_index = deputy_full.index('-')
    chief6_title = deputy_full[0..deputy_dash_index-2]
    chief6_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name

office = subordinates[26]
  entity_name = office.css('a')[0].text.strip
  website = office.css('a')[1].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[5].text
  chief_full = office.css('tr')[6].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[5].text.strip.index('$')
  if salary_start_index != nil
    salary = chief_full[salary_start_index..-1]
  end

  #chief2
  if office.css('tr')[7] != nil
    deputy_full = office.css('tr')[7].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name

office = subordinates[27]
  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  website = office.css('tr')[2].text.strip
  description = office.css('tr')[3].text
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[4].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]

  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name

subordinates[28..31].each do |office|
  entity_name = office.css('a').text.strip
  description = office.css('tr')[0].text
  if office.css('tr')[1] != nil
    chief_full = office.css('tr')[1].text.strip
    dash_index = chief_full.index('-')
    chief_title = chief_full[0..dash_index-2]
    salary_string_index = chief_full.index('Salary')
    #subordinate chiefs info
    if salary_string_index == nil
      chief_name_endpoint = -1
    else
      chief_name_endpoint = salary_string_index-3
    end
    #chief 1
    chief_name = chief_full[dash_index+3..chief_name_endpoint]
    salary_start_index = office.css('tr')[1].text.strip.index('$')
    if salary_start_index != nil
      salary = chief_full[salary_start_index..-1]
    end
    #chief 2
    if office.css('tr')[2] != nil
      deputy_full = office.css('tr')[2].text.strip
      deputy_dash_index = deputy_full.index('-')
      deputy_title = deputy_full[0..deputy_dash_index-2]
      deputy_name = deputy_full[deputy_dash_index+3..-1]
    end
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
end

office = subordinates[32]
  entity_name = office.css('a')[0].text.strip
  website = office.css('a')[1].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[4].text
  chief_full = office.css('tr')[5].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[5].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]
  
  #chief2
  if office.css('tr')[6] != nil
    deputy_full = office.css('tr')[6].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name

office = subordinates[33]
  entity_name = office.css('a')[0].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  website = office.css('tr')[2].text.strip
  description = office.css('tr')[3].text
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[4].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]

  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name

subordinates[34..35].each do |office|
  entity_name = office.css('a')[0].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  website = office.css('tr')[3].text.strip
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[4].text.strip.index('$')
  if salary_start_index != nil
    salary = chief_full[salary_start_index..-1]
  end

  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name
end

#######################
office = subordinates[38]
  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[3].text
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[4].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]

  #chief2
  if office.css('tr')[5] != nil
    deputy_full = office.css('tr')[5].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name.to_s + ' ' + chief_name.to_s + ' ' + salary.to_s + ' ' + deputy_name.to_s

#######################
office = subordinates[40]
  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[2].text
  chief_full = office.css('tr')[3].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[3].text.strip.index('$')
  if salary_start_index != nil
    salary = chief_full[salary_start_index..-1]
  end

  #chief2
  if office.css('tr')[4] != nil
    deputy_full = office.css('tr')[4].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name.to_s + ' ' + chief_name.to_s + ' ' + salary.to_s + ' ' + deputy_name.to_s

office = subordinates[41]
  entity_name = office.css('a')[0].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  website = office.css('tr')[2].text.strip
  description = office.css('tr')[3].text
  chief_full = office.css('tr')[4].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[4].text.strip.index('$')
  salary = chief_full[salary_start_index..-1]

  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name

office = subordinates[42]
  entity_name = office.css('a')[0].text.strip
  website = office.css('a')[1].text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[4].text
  chief_full = office.css('tr')[5].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')

  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[5].text.strip.index('$')
  if salary_start_index != nil
    salary = chief_full[salary_start_index..-1]
  end

  #chief2
  if office.css('tr')[6] != nil
    deputy_full = office.css('tr')[6].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name + ' ' + chief_name + ' ' + salary + ' ' + deputy_name


subordinates[43..44].each do |office|
  entity_name = office.css('a').text.strip
  address = office.css('tr')[0].text
  phone = office.css('tr')[1].text.strip
  description = office.css('tr')[2].text
  chief_full = office.css('tr')[3].text.strip
  dash_index = chief_full.index('-')
  chief_title = chief_full[0..dash_index-2]
  salary_string_index = chief_full.index('Salary')
  
  #subordinate chiefs info
  if salary_string_index == nil
    chief_name_endpoint = -1
  else
    chief_name_endpoint = salary_string_index-3
  end
  #chief 1
  chief_name = chief_full[dash_index+3..chief_name_endpoint]
  salary_start_index = office.css('tr')[3].text.strip.index('$')
  if salary_start_index != nil
    salary = chief_full[salary_start_index..-1]
  end
  
  #chief2
  if office.css('tr')[4] != nil
    deputy_full = office.css('tr')[4].text.strip
    deputy_dash_index = deputy_full.index('-')
    deputy_title = deputy_full[0..deputy_dash_index-2]
    deputy_name = deputy_full[deputy_dash_index+3..-1]
  end
  puts entity_name.to_s + ' ' + chief_name.to_s + ' ' + salary.to_s + ' ' + deputy_name.to_s
end