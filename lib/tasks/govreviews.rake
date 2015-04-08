namespace :govreviews do
  desc "Crawl NY State agencies and load them into PublicEntity table"
  task crawl_state_agencies: :environment do
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
      category = []
      category.push(markup.css("div[class='category']").text)
      results = { }
      results = { name: agency_name, description: description, website: website, authority_level: 'state', entity_type: 'agency', category: category }
      all_results.push(results)
    end
    
    all_results.each do |entity|
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type])
      entity[:category].each do |catg|
        c = Category.find_or_create_by(name: catg)
        pe.categories.push(c)
      end
    end
  end
  
  desc "Crawl NY City agencies and load them into PublicEntity table"
  task crawl_city: :environment do
    require 'rubygems'
    require 'nokogiri'
    require 'JSON'
    
    file = File.read('/Users/awhughes/Desktop/nyc.html')
    giri_file = Nokogiri::HTML(file)
    agency_section = giri_file.css("ul[class=alpha-list]").css('li')

    all_results = []

    agency_section.each do |agency|
      name = agency.text
        name = name[1..-2]
      description = agency["data-desc"]
      cat_info = agency["data-topic"]
      cat_json = JSON.parse(cat_info)
      website = agency["data-social-email"]
      results = { name: name, description: description, website: website, authority_level: 'city', category: cat_json['topics'] }
      all_results.push(results)
    end
    
    all_results.each do |entity|
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: 'agency')
      entity[:category].each do |catg|
        c = Category.find_or_create_by(name: catg)
        pe.categories.push(c)
      end
    end
  end
  
  desc "Crawl NY State Parks and load them into PublicEntity table"
  task crawl_parks: :environment do
    require 'rubygems'
    require 'JSON'
    
    file = File.read('/Users/awhughes/Desktop/NYS Parks.json')
    output = JSON.parse(file)
    page = output['data']
    all_results = []

    page.each do |park|
      name = park[8] + ' ' + park[9]
      description = park[9]
      website = park[17][0]
      results = { name: name, description: description, website: website, authority_level: 'state', entity_type: 'park' }
      all_results.push(results)
    end
    
    c = Category.create(name: 'Park')
    
    all_results.each do |entity|
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type])
      pe.categories.push(c)
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
