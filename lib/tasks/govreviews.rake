namespace :govreviews do
  desc "Crawl NYS agencies and load them into PublicEntity table"
  task crawl_entities: :environment do
    require 'rubygems'
    require 'nokogiri'
    require 'json'
    
    file = File.read('/Users/awhughes/Desktop/nys.json')
    parsed_file = JSON.parse(file)

    page = parsed_file['data']
    
    all_results = []

    page.each do |get_markup|
        markup = Nokogiri::HTML(get_markup['markup'])
        agency_name = markup.css('h3')[0].text
        description = markup.css('p')[0].text
          period_position = description.index('.')
          description = description[3..period_position]
        website = markup.css('p').css("a")[0].text
        results = {}
        results = { name: agency_name, description: description, website: website, authority_level: 'state' }
        all_results.push(results)
    end
    
    all_results.each do |entity|
      PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level])
    end
  end
  
  desc "Crawl NYC agencies and load them into PublicEntity table"
  task crawl_city: :environment do
    require 'rubygems'
    require 'nokogiri'
    
    file = File.read('/Users/awhughes/Desktop/nyc.html')
    
    giri_file = Nokogiri::HTML(file)

    agency_section = giri_file.css("ul[class=alpha-list]").css('li')

    all_results = []

    agency_section.each do |agency|
      name = agency.text
        name = name[1..-2]
      description = agency["data-desc"]
      website = agency["data-social-email"]
      results = { name: name, description: description, website: website, authority_level: 'city' }
      all_results.push(results)
    end
    
    all_results.each do |entity|
      PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level])
    end
  end
  
end

#first_page = Nokogiri::HTML(parsed_file['data'][99]['markup'])

#agency_name = first_page.css('h3')[0].text
#description = first_page.css('p')[0].text
#website = first_page.css('p').css("a")[0].text

#period_position = description.index('.')
#description = description[1..period_position]

#results = []
#results.push([agency_name, description, website])

#puts results
