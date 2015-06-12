namespace :govreviews do
  desc "Crawl NY State agencies and load them into PublicEntity table"
  task crawl_state_agencies: :environment do
    require 'rubygems'
    require 'nokogiri'
    require 'json'
    require 'open-uri'
    
    url = 'http://www.ny.gov/services/nygov/search?draw=2&columns%5B0%5D%5Bdata%5D=markup&columns%5B0%5D%5Bname%5D=&columns%5B0%5D%5Bsearchable%5D=true&columns%5B0%5D%5Borderable%5D=false&columns%5B0%5D%5Bsearch%5D%5Bvalue%5D=&columns%5B0%5D%5Bsearch%5D%5Bregex%5D=false&order%5B0%5D%5Bcolumn%5D=0&order%5B0%5D%5Bdir%5D=asc&start=0&length=100&search%5Bvalue%5D=&search%5Bregex%5D=false&entity_types%5B0%5D=taxonomy_term&bundles%5B0%5D=agency&keywords=&searchgroup_id=agency&searcher_id=agency'
    file = open(url) { |f| f.read }
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
      governor = PublicEntity.where(name: "The Governor of New York")[0]
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type], superior: governor)
      entity[:category].each do |catg|
        c = Category.find_or_create_by(name: catg)
        pe.categories.push(c)
      end
    end
  end
  
  desc "Crawl NY City agencies and load them into PublicEntity table"
  task crawl_city_agencies: :environment do
    require 'rubygems'
    require 'nokogiri'
    require 'json'
    require 'open-uri'
    
    url = 'http://www1.nyc.gov/nyc-resources/agencies.page'
    file = open(url) { |f| f.read }
    giri_file = Nokogiri::HTML(file)
    agency_section = giri_file.css("ul[class=alpha-list]").css('li')

    all_results = []
    mayor = PublicEntity.where(name: "The Mayor of New York City").first

    agency_section.each do |agency|
      name = agency.text
        name = name[1..-2]
      description = agency["data-desc"]
      cat_info = agency["data-topic"]
      cat_json = JSON.parse(cat_info)
      website = agency["data-social-email"]
      superior_id = mayor.id
      #get contact info
      #if website.index('www.nyc.gov') != nil
      #  web_url = website.gsub('home/home.shtml', 'contact/contact.shtml')
      #  file = open(web_url) { |f| f.read }
      #  giri_file = Nokogiri::HTML(file)
      #  street_address = giri_file.css('span').css('p')[0].children[0].text
      #  city_and_zip = giri_file.css('span').css('p')[0].children[2].text
      #  address = street_address + ' ' + city_and_zip
      #  phone = giri_file.css('span').css('p')[0].children[4].text
      #  fax = giri_file.css('span').css('p')[0].children[6].text[0..11]
      #else
      #  phone = nil
      #  address = nil
      #end
      results = { name: name, description: description, website: website, authority_level: 'city', category: cat_json['topics'], superior_id: superior_id }
      all_results.push(results)
    end
    
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
  end
  
  desc "Crawl NY State Parks and load them into PublicEntity table"
  task crawl_state_parks: :environment do
    require 'rubygems'
    require 'json'
    require 'open-uri'
    
    url = 'https://data.ny.gov/api/views/9uuk-x7vh/rows.json?accessType=DOWNLOAD'
    file = open(url) { |f| f.read }
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
    
    c = Category.create(name: 'Parks')
    
    all_results.each do |entity|
      state_park_authority = PublicEntity.find_by(name: "Office of Parks, Recreation and Historic Preservation")
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type], superior: state_park_authority)
      pe.categories.push(c)
    end
  end
  
  desc "Crawl Post Offices in New York City and load them into PublicEntity table"
  task crawl_post_offices: :environment do
    require 'rubygems'
    require 'json'
    require 'open-uri'
    
    url = 'https://data.cityofnewyork.us/api/views/bdha-6eqy/rows.json?accessType=DOWNLOAD'
    file = open(url) { |f| f.read }
    output = JSON.parse(file)
    page = output["data"]

    all_results = []

    page.each do |office|
      name = office[9] + ' ' + 'Post Office'
      description = "Post Office"
      website = "http://www.usps.com"
      results = { name: name, description: description, website: website, authority_level: 'federal', entity_type: 'post_office' }
      all_results.push(results)
    end

    c = Category.create(name: 'Post Offices')

    all_results.each do |entity|
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type])
      pe.categories.push(c)
    end
  end
  
  desc "Crawl NYC Subway Stations and load them into PublicEntity table"
  task crawl_subway_stations: :environment do
    require 'json'
    require 'rubygems'
    require 'open-uri'
    
    url = 'https://data.cityofnewyork.us/api/views/kk4q-3rt2/rows.json?accessType=DOWNLOAD'
    page = open(url) { |f| f.read }
    output = JSON.parse(page)
    info = output["data"]

    all_results = []

    info.each do |station|
      name = station[9]
      description = "Subway station servicing lines" + " " + station[10]
      website = station[8]
      results = {}
      results = { name: name, description: description, website: website, authority_level: "city", entity_type: "subway_station", category: ["Transportation", "Subway Stations"] }
      all_results.push(results)
    end

    all_results.each do |entity|
      #mta_nycta = create Public Entity!
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type])
      entity[:category].each do |catg|
        c = Category.find_or_create_by(name: catg)
        pe.categories.push(c)
      end
    end
  end
  
  desc "Crawl Greenbook for Mayor and Incumbent"
  task crawl_greenbook_for_mayor: :environment do
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
      mayor_info = nokofile.css('.tel')[0].text
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
    mayor.categories.push(catg)
    mayor.chiefs.push(incumbent)
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
