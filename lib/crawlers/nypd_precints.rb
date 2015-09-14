#desc "Crawl NYPD Precincts and Captains"
#task crawl_nypd_precincts: :environment do
require 'open-uri'
require 'Nokogiri'

url = "http://www.nyc.gov/html/nypd/html/home/precincts.shtml"
content = open(url) { |f| f.read }
nypd_content = Nokogiri::HTML(content)

precinct_links = nypd_content.css('tbody').css('tr')
precinct_links_array = []

precinct_links.each do |precinct|
  link_suffix = precinct.css('a')[0].attributes['href'].value[3..-1]
  link_prefix = "http://www.nyc.gov/html/nypd/html/"
  link = link_prefix + link_suffix
  precinct_links_array.push(link)
end

precinct_links_array.each do |link|
  content = open(link) { |f| f.read }
  precinct_content = Nokogiri::HTML(content)
  website = link
  puts link
  name_and_title = precinct_content.css('span').css('.bodytext b')[0].text
  puts name_and_title
#  title = "Captain"
#  name = name_and_title[8..-1]
#  twitter_text = precinct_content.css('.twitter-follow-button')[0].text
#  twitter_handle = precinct_content.css('.twitter-follow-button')[0].text[7..-1]
#  puts twitter_handle
#  twitter_link = precinct_content.css('.twitter-follow-button')[0]['href']
#  address = precinct_content.css('.bodytext')[0].children[15].text.strip
#  puts address
#  precinct_phone = precinct_content.css('.bodytext')[2].children[1].text.strip
#  puts precinct_phone
#  community_affairs_phone = precinct_content.css('.bodytext')[2].children[4].text.strip
#  puts community_affairs_phone
#  crime_prevention_phone = precinct_content.css('.bodytext')[2].children[7].text.strip
#  puts crime_prevention_phone
#  domestic_violence_phone = precinct_content.css('.bodytext')[2].children[10].text.strip
#  puts domestic_violence_phone
#  youth_officer_phone = precinct_content.css('.bodytext')[2].children[13].text.strip
#  puts youth_officer_phone
#  auxiliary_coordinator_phone = precinct_content.css('.bodytext')[2].children[16].text.strip
#  puts auxiliary_coordinator_phone
#  detective_squad = precinct_content.css('.bodytext')[2].children[19].text.strip
#  puts detective_squad
#  description = precinct_content.css('.bodytext')[0].children[20].text.strip
#  puts description
#  community_council_president = precinct_content.css('.bodytext')[4].children[1].text.strip
#  puts community_council_president
#  community_council_meetings = precinct_content.css('.bodytext')[4].children[4].text.strip
#  puts community_council_meetings
  puts ""
  sleep(1)
end