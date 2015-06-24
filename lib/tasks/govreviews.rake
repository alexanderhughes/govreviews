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
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type], superior: governor, source: "NY.gov", source_accessed: Time.now )
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
      results = { name: name, description: description, website: website, authority_level: 'city', category: cat_json['topics'], superior_id: superior_id }
      all_results.push(results)
    end
    
    all_results.each do |entity|
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: 'agency', superior: mayor, source: "NYC.gov", source_accessed: Time.now )
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
    require 'openssl'
    
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    url = 'https://data.ny.gov/api/views/9uuk-x7vh/rows.json?accessType=DOWNLOAD'
    file = open(url) { |f| f.read }
    output = JSON.parse(file)
    page = output['data']
    all_results = []

    page.each do |park|
      name = park[8] + ' State Park'
      if park[9] = "Other"
        description = nil
      else
        description = park[9]
      end
      county = park[11]
      state = "New York"
      address = name + ', ' + county + ', ' + state
      website = park[17][0]
      results = { name: name, address: address, description: description, website: website, authority_level: 'state', entity_type: 'park' }
      all_results.push(results)
    end
    
    c = Category.create(name: 'Park')
    
    all_results.each do |entity|
      state_park_authority = PublicEntity.find_by(name: "Office of Parks, Recreation and Historic Preservation")
      pe = PublicEntity.create(name: entity[:name], address: entity[:address], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type], superior: state_park_authority, source: "data.ny.gov", source_accessed: Time.now )
      pe.categories.push(c)
    end
  end
  
  desc "Crawl Post Offices in New York City and load them into PublicEntity table"
  task crawl_post_offices: :environment do
    require 'rubygems'
    require 'json'
    require 'open-uri'
    require 'openssl'
    
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    url = 'https://data.cityofnewyork.us/api/views/bdha-6eqy/rows.json?accessType=DOWNLOAD'
    file = open(url) { |f| f.read }
    output = JSON.parse(file)
    page = output["data"]

    all_results = []

    page.each do |office|
      name = office[9] + ' ' + 'Post Office'
      address = office[8] + ' ' + office[10].split.map(&:capitalize).join(' ') + ', ' + office[11] + ', NY, ' + office[12] 
      description = "Post Office"
      website = "http://www.usps.com"
      results = { name: name, address: address, description: description, website: website, authority_level: 'federal', entity_type: 'post_office' }
      all_results.push(results)
    end

    c = Category.create(name: 'Post Offices')

    all_results.each do |entity|
      pe = PublicEntity.create(name: entity[:name], address: entity[:address], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type], source: "NYCOpenData", source_accessed: Time.now )
      pe.categories.push(c)
      sleep(0.5)
    end
  end
  
  desc "Crawl NYC Subway Stations and load them into PublicEntity table"
  task crawl_subway_stations: :environment do
    require 'json'
    require 'rubygems'
    require 'open-uri'
    require 'openssl'
    
    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    url = 'https://data.cityofnewyork.us/api/views/kk4q-3rt2/rows.json?accessType=DOWNLOAD'
    page = open(url) { |f| f.read }
    output = JSON.parse(page)
    info = output["data"]

    all_results = []

    info.each do |station|
      name = station[9] + " Subway Station"
      description = "Subway station servicing lines" + " " + station[10] + "."
      website = station[8]
      results = {}
      results = { name: name, description: description, website: website, authority_level: "city", entity_type: "subway_station", category: ["Transportation", "Subway Stations"] }
      all_results.push(results)
    end

    all_results.each do |entity|
      #mta_nycta = create Public Entity!
      pe = PublicEntity.create(name: entity[:name], description: entity[:description], website: entity[:website], authority_level: entity[:authority_level], entity_type: entity[:entity_type], source: "NYCOpenData", source_accessed: Time.now)
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
    agency = { name: entity_name, address: address, phone: phone, website: website, email: email, description: description, authority_level: "city", entity_type: "city executive", source: "NYC Greenbook", source_accessed: Time.now }
    mayor = PublicEntity.create(name: agency[:name], authority_level: agency[:authority_level], address: agency[:address], description: agency[:description], website: agency[:website], entity_type: agency[:entity_type], phone: agency[:phone])
    catg = Category.find_or_create_by(name: "Political Officer")
    mayor.categories.push(catg)
    mayor.chiefs.push(incumbent)
  end

  desc "Crawl Greenbook for Sub Agencies and Chiefs"
  task crawl_greenbook_mayor_sub_agencies: :environment do
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

    subordinates[2..41].each do |office|

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
          #check if not a phone number, fax number, TTY number, address, website, empty string, nil, and not a description, then it is an agency chief string
          if position[m].text.strip.index(/\(\d/) == nil && 
            position[m].text.strip.index("Fax") != 0 &&
            position[m].text.strip.index("TTY") != 0 &&
            position[m].text.strip[0] != "" &&
            position[m].text.strip != nil &&
            position[m].text.strip.length <= 120 &&
            position[m].text.strip.index("Ex-") == nil &&
            position[m].text.strip.index("Painter") == nil &&
            position[m].text.strip.index("Term") == nil &&
            position[m].text.strip.index("New York, NY") == nil &&
            position[m].text.strip.index("Ave.") == nil &&
            position[m].text.strip.index("St.") == nil &&
            position[m].text.strip.index(".gov") == nil
            #assign chief string
            chief_full = position[m].text.strip
            dash_index = chief_full.index('-')
            if dash_index != nil
              #if there's a dash, get the title before the name
              chief_title = chief_full[0..dash_index-2]
              salary_string_index = chief_full.index('Salary')
              if salary_string_index == nil
                chief_name_endpoint = -1
              else
                chief_name_endpoint = salary_string_index-3
              end
              chief_name = chief_full[dash_index+3..chief_name_endpoint]
              if chief_name.index("Vacant") != nil
                chief_name = nil
                vacant = true
              end
              if salary_string_index != nil
                salary = chief_full[salary_string_index+9..-1]
              else
                salary = nil
              end
            else
              chief_title = chief_full[0..-1]
              chief_name = nil
              salary = nil
            end
            chief = { name: chief_name, title: chief_title, salary: salary }
            chiefs.push(chief)
          else
            chief_full = nil
          end
          m += 1
        end
      else
        next
      end
      subordinate_hash = { name: entity_name, website: website, address: address, phone: phone, description: description, chiefs: chiefs}
      subordinates_array.push(subordinate_hash)
    end

    subordinates_array.each do |subordinate_hash|
      mayor = PublicEntity.find_by(name: "Mayor, Office of the (OTM)")
      pe = PublicEntity.create(name: subordinate_hash[:name], website: subordinate_hash[:website], address: subordinate_hash[:address], phone: subordinate_hash[:phone], description: subordinate_hash[:description], authority_level: "city", entity_type: "agency", superior: mayor, source: "NYC Greenbook", source_accessed: Time.now)
      subordinate_hash[:chiefs].each do |chief|
        c = Chief.find_or_create_by(name: chief[:name], title: chief[:title], salary: chief[:salary])
        pe.chiefs.push(c)
      end
      sleep(0.5)
    end
  end
  
  desc "Crawl Greenbook Main Page for Agencies"
  task crawl_greenbook_main_page: :environment do
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

    all_agencies = [] #initiate array to push all agencies into

    agency_links[1..-1].each do |agency_link|
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
  
      results = { }
      results = { name: entity_name, address: address, phone: phone, website: website, email: email, description: description }
      all_agencies.push(results)
    end

    #create Public Entity for each item on the main page
    all_agencies.each do |agency|
      mayor = PublicEntity.find_by(name: "Mayor, Office of the (OTM)")
      new_agency = PublicEntity.create(name: agency[:name], authority_level: 'city', address: agency[:address], phone: agency[:phone], description: agency[:description], entity_type: 'agency', website: agency[:website], superior: mayor, source: "NYC Greenbook", source_accessed: Time.now)
      sleep(0.5)
    end
  end
  
  desc "Crawl DMV Offices"
  task crawl_dmv_offices: :environment do
    require 'json'
    require 'rubygems'
    require 'open-uri'
    require 'openssl'

    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    url = 'https://data.ny.gov/api/views/9upz-c7xg/rows.json?accessType=DOWNLOAD'
    output = open(url) { |f| f.read }
    json_data = JSON.parse(output)

    all_ny_state_dmv_offices = []
    
    json_data['data'].each do |office|
      phone = office[10]
      office_type = office[9]
      if office_type == 'CO'
        office_description = 'County-run DMV office.'
      elsif office_type == 'DO'
        office_descripton = 'State-run DMV office.'
      elsif office_type == 'MO'
        office_description = 'County-run mobile DMV office.'
      elsif office_type == 'TV'
        office_description = 'Traffic violations DMV office.'
      elsif office_type == 'VS'
        office_description = 'Vehicle safety DMV office.'
      end
      name = office[8].split.map(&:capitalize).join(' ') + ' DMV'
      street_address = office[12]
      zip = office[16]
      city = office[14]
      state = office[15]
      full_address = street_address + ', ' + city + ', ' + state + ', ' + zip
      monday = []
      if office[17] !~ /[^[:space:]]/
        monday = nil
      else
        monday.push(office[17], office[18])
      end
      tuesday = []
      if office[19] !~ /[^[:space:]]/
        tuesday = nil
      else
        tuesday.push(office[19], office[20])
      end
      wednesday = []
      if office[21] !~ /[^[:space:]]/
        wednesday = nil
      else
        wednesday.push(office[21], office[22])
      end
      thursday = []
      if office[23] !~ /[^[:space:]]/
        thursday = nil
      else
        thursday.push(office[23], office[24])
      end
      friday = []
      if office[25] !~ /[^[:space:]]/
        fiday = nil
      else 
        friday.push(office[25], office[26])
      end
      saturday = []
      if office[27] !~ /[^[:space:]]/
        saturday = nil
      else
        saturday.push(office[27], office[28])
      end
      hours = {}
      hours = { monday: monday, tuesday: tuesday, wednesday: wednesday, thursday: thursday, friday: friday, saturday: saturday }
      
      dmv = {}
      dmv = { name: name, description: office_description, phone: phone, address: full_address, hours: hours, source: "data.ny.gov", source_accessed: Time.now }
      ### add description / office type!
      all_ny_state_dmv_offices.push(dmv)
    end
    
    state_dmv = PublicEntity.find_by(name: "Department of Motor Vehicles")
    all_ny_state_dmv_offices.each do |dmv|
      pe = PublicEntity.create(name: dmv[:name], description: dmv[:description], phone: dmv[:phone], address: dmv[:address], hours: dmv[:hours], source: dmv[:source], source_accessed: dmv[:source_accessed], website: "http://dmv.ny.gov/", entity_type: "DMV", superior: state_dmv, authority_level: "state" )
      cat = Category.find_or_create_by(name: 'DMV')
      cat2 = Category.find_or_create_by(name: 'Transportation')
      pe.categories.push(cat, cat2)
      sleep(0.5)
    end
  end
  
end
