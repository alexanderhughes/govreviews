require 'nokogiri'
require 'open-uri'

mayor_page_link = 'http://a856-gbol.nyc.gov/gbolwebsite/390.html'
mayor_page = open(mayor_page_link) { |f| f.read }
nokofile = Nokogiri::HTML(mayor_page)

#get subordinates table
subordinates = nokofile.css('table')

#initiate array for subordinates
subordinates_array = []
#initialize hash
subordinate_hash = {}

subordinates[2..-2].each do |office|

  if office.css('a')[0] != nil

    entity_name = office.css('a')[0].text.strip

    if office.css('a')[1] != nil && office.css('a')[1].text.index('.gov') != nil
      website = office.css('a')[1].text.strip
    else
      website = nil
    end

    #get address
    n = 0
    while office.css('tr')[n] != nil
      if office.css('tr')[n].text.index('New York, NY') != nil
        address = office.css('tr')[n].text.strip
        break
      else
        address = nil
      end
      n += 1
    end
    
    #get phone
    n = 0
    while office.css('tr')[n] != nil
      if office.css('tr')[n].text.strip[0] == '('
        phone = office.css('tr')[n].text.strip
        break
      else
        phone = nil
      end
      n += 1
    end
    
    #get description
    n = 0
    while office.css('tr')[n] != nil
      if office.css('tr')[n].text.strip.length >= 90 && n <= 6
        description = office.css('tr')[n].text.strip
        break
      else
        description = nil
      end
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
  subordinate_hash = { name: entity_name, website: website, address: address, phone: phone, description: description, chiefs: chiefs}
  puts ">> " + subordinate_hash[:name].to_s
  puts "> " + subordinate_hash[:chiefs][0][:name].to_s
  puts "> " + subordinate_hash[:chiefs][0][:salary].to_s
  subordinates_array.push(subordinate_hash)
end

puts subordinates_array[0][:name].to_s
=begin
subordinates_array.each do |agency|
  pe = PublicEntity.create(name: subordinate_hash[:name], website: subordinate_hash[:website], address: subordinate_hash[:address], phone: subordinate_hash[:phone], description: subordinate_hash[:description], authority_level: "city", entity_type: "city agency")
  chiefs = []
  subordinate_hash[:chief].each do |chief|
    c = Chief.create(name: chief[:name], title: chief[:title], salary: chief[:salary])
    pe.chiefs.push(c)
  end
end
=end