require 'json'
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

agency_link = agency_links[0]
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
  #get subordinates table
  subordinates = nokofile.css('table')

  puts entity_name

  subordinates[2..-2].each do |office|
  
    if office.css('a')[0] != nil
      entity_name = office.css('a')[0].text.strip
      puts ">> " + entity_name
  
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

  
  
  #end