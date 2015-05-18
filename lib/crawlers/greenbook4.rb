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
  description = mission + ' ' + des

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
    authority_source = 'Appointed'
  end


subordinates[2..45].each do |office|
  
  if office.css('a')[0] != nil
    entity_name = office.css('a')[0].text.strip
    puts entity_name
  
    if office.css('a')[1] != nil && office.css('a')[1].text.index('.gov') != nil
      website = office.css('a')[1].text.strip
    else
      website = nil
    end
  
    n = 0
    while office.css('tr')[n] != nil
      #get address
      if office.css('tr')[n].text.index('New York, NY') != nil
        address = office.css('tr')[n].text.strip
      else
        address = nil
      end
      #get phone
      if office.css('tr')[n].text.strip[0] == '('
        phone = office.css('tr')[n].text.strip
      else
        phone = nil
      end
      #get description
      if office.css('tr')[n].text.strip.length >= 90 && n <= 6
        description = office.css('tr')[n].text.strip
      else
        description = nil
      end
      #increment counter
      n += 1
    end
    
    m = 0
    chief_info = []
    position = office.css('tr')
    while position[m] != nil && m <= 12
      #check if not a phone number, fax number, TTY number, empty string, or nil, not a description, then it is an agency chief string
      if position[m].text.strip.index(/\(\d/) == nil && 
        position[m].text.strip.index("Fax") != 0 &&
        position[m].text.strip.index("TTY") != 0 &&
        position[m].text.strip[0] != "" &&
        position[m].text.strip != nil &&
        position[m].text.strip.length <= 120 &&
        position[m].text.strip.index("Ex-") == nil &&
        position[m].text.strip.index("Term") == nil
        chief_full = position[m].text.strip
        dash_index = chief_full.index('-')
        if dash_index != nil    
          chief_title = chief_full[0..dash_index-2]
          salary_string_index = chief_full.index('Salary')
          if salary_string_index == nil
            chief_name_endpoint = -1
          else
            chief_name_endpoint = salary_string_index-3
          end
          chief_name = chief_full[dash_index+3..chief_name_endpoint]
          salary_start_index = chief_full.index('$')
          if salary_start_index != nil
            salary = chief_full[salary_start_index..-1]
          else
            salary = nil
          end
          puts "> " + chief_name + ">> " + chief_title + ">> " + salary.to_s 
        end
      else
        chief_full = nil
      end
      m += 1
    end
  end
end

  