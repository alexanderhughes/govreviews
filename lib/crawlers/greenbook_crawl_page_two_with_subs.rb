require 'nokogiri'
require 'open-uri'

mayor_page_link = 'http://a856-gbol.nyc.gov/gbolwebsite/390.html'
mayor_page = open(mayor_page_link) { |f| f.read }
nokofile = Nokogiri::HTML(mayor_page)

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

#Get incumbent mayor info

if nokofile.css('.tel')[0] != nil
  mayor_info = nokofile.css('tel')[0].text
  find_first_space = mayor_info.index(' ')
  title = mayor_info[0..find_first_space-1]
  salary_string_index = mayor_info.index('Salary: $')
  name = mayor_info[find_first_space+4..salary_string_index-3]
  dollar_sign_index = mayor_info.index('$')
  period_index = mayor_info.index('.')
  salary = mayor_info[dollar_sign_index+1..period_index-1]
  election_info = mayor_info[period_index+2..-1]
else
  title = nil
  name = nil
  salary = nil
  election_info = nil
end

incumbent = Chief.create(name: name, title: title, salary: salary, election_info: election_info)

#add mayor to database
agency = {}
agency = { name: entity_name, address: address, phone: phone, website: website, email: email, description: description, authority_level: "city", entity_type: "city executive" }
mayor = PublicEntity.create(name: agency[:name], authority_level: agency[:authority_level], address: agency[:address], description: agency[:description], website: agency[:website], entity_type: agency[:entity_type], phone: agency[:phone])
catg = Category.find_or_create_by(name: "Political Officer")
mayor.push(catg)
mayor.push(incumbent)

#get subordinates table
subordinates = nokofile.css('table')

#initiate array for subordinates
subordinates_array = []

subordinates[2..-2].each do |office|
  #initialize hash
  subordinate_hash = {}

  if office.css('a')[0] != nil
    
    entity_name = office.css('a')[0].text.strip

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
    chiefs = []
    chief = {}
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
          chief = { name: chief_name, title: chief_title, salary: salary }
          chiefs.push(chief) 
        end
      else
        chief_full = nil
      end
      m += 1
    end
  end
  subordinate_hash = { name: entity_name, website: website, address: address, phone: phone, description: description, authority_level: "city", entity_type: "city agency", chief: chiefs}
end



#end
=end