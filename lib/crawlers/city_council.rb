=begin
#Clean up entry and remove duplicate
city_council_1 = PublicEntity.find_by(name: "City Council (NYCC)")
city_council_2 = PublicEntity.find_by(name: "City Council, New York")

#Remove mayor as superior
city_council_1.superior = nil
city_council_1.save

#Add website
city_council_1.website = city_council_2.website
city_council_1.save

#Add categories
cc_categories = city_council_2.categories
city_council_1.categories.push(cc_categories)
city_council_1.save

#Combine descriptions
city_council_1.description = city_council_1.description + " " + city_council_2.description
city_council_1.save

#Add source
city_council_1.source = "NYC.gov, NYC Greenbook"
city_council_1.save

#Delete duplicate
city_council_2.delete!
=end

#Add Chiefs to City Council
#Get links for each chief
require 'open-uri'
require 'Nokogiri'

url = 'http://council.nyc.gov/html/members/members.shtml'
content = open(url) { |f| f.read }

#parse with Nokogiri
parsed_content = Nokogiri::HTML(content)

#Pull out nodeset of link elements
member_page_links = parsed_content.css('td').css('.list_entry').css('a')

#initialize empty array
all_links = []

member_page_links.each do |member|
  short_link = member.attributes['href'].value
  link = 'http://council.nyc.gov' + short_link
  all_links.push(link)
end

#initialize empty chief hash
chief = {}

all_links.each do |member_page_link|
  member_page_content = open(member_page_link) { |f| f.read }
  parsed_page_content = Nokogiri::HTML(member_page_content)
  top_box = parsed_page_content.css('td').css('.inside_top_text')
  #council member info
  if top_box[0] != nil
    council_member_name = top_box[0].children.css('h1').text.strip
    council_member_desc = top_box[0].children[2].text.strip
    if council_member_desc.empty? == false
      dash_index = council_member_desc.index("-")
      if dash_index != nil
        district = council_member_desc[9..dash_index-2]
        dash_2_index = council_member_desc[dash_index+1..-1].index("-")
        if dash_2_index != nil
          political_party = council_member_desc[(dash_2_index+dash_index)+3..-1]
        end
      end
    end
    image_extension = parsed_page_content.css(".inside_top_image").children[0].attributes['src'].value[6..-1]
    image_link = member_page_link.gsub('html/members/home.shtml', image_extension)
  else
    council_member_name = "Vacant"
  end
  
  #contact info
  contact_box = parsed_page_content.css('td').css('.nav_section')
  contact_info_section = contact_box.children[0].children[3].children[1].children
  district_office_address = contact_info_section[3].text.strip
  district_office_phone = contact_info_section[9].text.strip
  district_office_fax = contact_info_section[15].text.strip
  legislative_office_address = contact_info_section[21].text.strip
  legislative_office_phone = contact_info_section[27].text.strip
  legislative_office_fax = contact_info_section[33].text.strip
  email_string = contact_info_section.css('a')[0]['href'][7..-1]
  
  chief = { name: council_member_name, }
end

source = "http://council.nyc.gov/"
source_accessed = Time.now
  