require 'nokogiri'
require 'open-uri'

alphabet_letter = 65
all_letters_websites = []

#for full list use 0..25
for n in 0..1
  url = 'http://data.nysed.gov/lists.php?start='+ alphabet_letter.to_s + '&type=school'
  all_letters_websites.push(url)
  alphabet_letter += 1
end

school_info_pages = []

all_letters_websites.each do |alphabet_directory|
  alphabet_index_page = open(alphabet_directory) { |f| f.read }
  nokogiri_parsed_page = Nokogiri::HTML(alphabet_index_page)
  individual_school_listings = nokogiri_parsed_page.css("h5").css('a')
  individual_school_listings.each do |listing|
    individual_school_page = listing.attributes['href'].value
    school_info_pages.push(individual_school_page)
  end
end

school_info = []

school_info_pages.each_with_index do |school, i|
  if i > 2
    break
  end
  puts i

  base_url = 'http://data.nysed.gov/'
  url = base_url + school
  school_page = open(url) { |f| f.read }
  nokogiri_parsed_page = Nokogiri::HTML(school_page)
  school_name_long = nokogiri_parsed_page.css('title').text.strip
  pipe_index = school_name_long.index("|")
  school_name = school_name_long[0..pipe_index-2]
  county = nokogiri_parsed_page.css('.breadcrumbs').css('li')[1].text
  school_district_link = base_url[0..-2]+nokogiri_parsed_page.css('.breadcrumbs').css('li').css('a')[2]['href']
  school_district = nokogiri_parsed_page.css('.breadcrumbs').css('li')[2].text
  principal_long = nokogiri_parsed_page.css('.nine').css('.school_facts')[0].text
  colon_index = principal_long.index(':')
  principal_name = principal_long[12..-1]
  school_address_long = nokogiri_parsed_page.css('.nine').css('.school_facts')[1].text
  ny_index = school_address_long.index('NY')
  school_address = school_address_long[9..ny_index+1]
  zip_code = school_address_long[ny_index+5..-1]
  sed_code = nokogiri_parsed_page.css('.panel').css('.school_facts')[3].text[10..-1]
  school_type_long = nokogiri_parsed_page.css('.panel').css('.school_facts')[4].text[6..-1]
  if school_type_long.index('Public') != nil
    school_type_short = "Public School"
  elsif school_type_long.index('Charter') != nil
    school_type_short = "Charter"
  end
  grade_configuration = nokogiri_parsed_page.css('.panel').css('.school_facts')[5].text[21..-1]
  school_phone = nokogiri_parsed_page.css('.panel').css('.school_facts')[6].text[7..-1]
  school_website = nokogiri_parsed_page.css('.panel').css('.school_facts')[7].text[9..-1]
  
  #get superintendent and school district info
  school_district_page = open(school_district_link) { |f| f.read }
  noko_parsed_super = Nokogiri::HTML(school_district_page)
  school_district_full_name = noko_parsed_super.css('.panel').css('.school_facts')[2].text[12..-1]
  superintendent = noko_parsed_super.css('.nine').css(".school_facts")[0].text[17..-1]
  superintendent_address_long = noko_parsed_super.css('.nine').css(".school_facts")[1].text[9..-1]
  ny_index = superintendent_address_long.index("NY")
  superintendent_address = superintendent_address_long[0..ny_index+1]
  superintendent_zip = superintendent_address_long[ny_index+5..-1]
  school_district_phone = noko_parsed_super.css('.panel').css('.school_facts')[5].text[7..-1]
  school_district_website = noko_parsed_super.css('.panel').css('.school_facts')[6].text[9..-1] 
  school_district_type_long = noko_parsed_super.css('.panel').css('.school_facts')[4].text[6..-1] 
  if school_district_type_long.index('Public') != nil
    school_district_type_short = "Public School"
  elsif school_district_type_long.index('Charter') != nil
    school_district_type_short = "Charter"
  end
  school_district_sed_code = noko_parsed_super.css('.panel').css('.school_facts')[3].text[10..-1]
  
  school_info.push(school_name, school_type_short)
end

puts school_info