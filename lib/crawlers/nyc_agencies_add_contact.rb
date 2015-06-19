require 'nokogiri'
require 'open-uri'
require 'json'

url = 'http://www1.nyc.gov/nyc-resources/agencies.page'
file = open(url) { |f| f.read }
giri_file = Nokogiri::HTML(file)
agency_section = giri_file.css("ul[class=alpha-list]").css('li')

all_results = []
#mayor = PublicEntity.where(name: "The Mayor of New York City").first

agency_section.each do |agency|
  name = agency.text
  name = name[1..-2]
  puts name.to_s
  description = agency["data-desc"]
  cat_info = agency["data-topic"]
  cat_json = JSON.parse(cat_info)
  website = agency["data-social-email"]
  #superior_id = mayor.id
  #get contact info
  if website.index('www.nyc.gov') != nil
    web_url = website.gsub('home/home.shtml', 'contact/contact.shtml')
    if web_url.index('contact/contact.shtml') != nil
      puts web_url.to_s
      file = open(web_url) { |f| f.read }
      giri_file = Nokogiri::HTML(file)
      street_address = giri_file.css('span').css('p')[0].children[0].text
      puts street_address.to_s
      #city_and_zip = giri_file.css('span').css('p')[0].children[2].text
      #address = street_address + ' ' + city_and_zip
      #phone = giri_file.css('span').css('p')[0].children[4].text
      #fax = giri_file.css('span').css('p')[0].children[6].text[0..11]
    else
      puts "WEBSITE WON'T WORK!"
    end
  else
    phone = nil
    address = nil
  end
  sleep(1)
  #results = { name: name, description: description, website: website, authority_level: 'city', category: cat_json['topics'], superior_id: superior_id }
  #all_results.push(results)
end

=begin
all_results.each do |entity|
  pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: 'agency', superior: mayor )
  entity[:category].each do |catg|
    catg = catg.capitalize.gsub('-',' ')
    if catg.index(' ') != nil
      space_index = catg.index(' ')
      catg = catg[0..space_index] + catg[space_index+1].capitalize + catg[space_index+2..-1]
    end
    c = Category.find_or_create_by(name: catg)
    pe.categories.push(c)
  end
end
=end