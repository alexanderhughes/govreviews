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
      agency_name = markup.css('h3')[0].text.strip
      description = markup.css('p')[0].text.strip
        period_position = description.index('.')
        description = description[3..period_position]
      website = markup.css('p').css("a")[0].text.strip
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
    mayor = PublicEntity.where(name: "Mayor, Office of the (OTM)").first

    agency_section.each do |agency|
      name = agency.text.strip
        name = name[1..-2]
      description = agency["data-desc"].strip
      cat_info = agency["data-topic"]
      cat_json = JSON.parse(cat_info)
      website = agency["data-social-email"].strip
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
      name = park[8].strip + ' State Park'
      if park[9] = "Other"
        description = nil
      else
        description = park[9]
      end
      county = park[11].strip
      state = "New York"
      address = name + ', ' + county + ', ' + state
      website = park[17][0].strip
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
      name = office[9].strip + ' ' + 'Post Office'
      address = office[8].strip + ' ' + office[10].split.map(&:capitalize).join(' ') + ', ' + office[11].strip + ', NY, ' + office[12].strip
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
      name = station[9].strip + " Subway Station"
      description = "Subway station servicing lines" + " " + station[10].strip + "."
      website = station[8].strip
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
      website = nokofile.css('#ContentPlaceHolder1_lblAgencyWebAddress').css('a')[0].attributes['href'].value.strip
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
      mission = nokofile.css('#ContentPlaceHolder1_lblMission').text.strip
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
      mayor_info = nokofile.css('.tel')[0].text.strip
      find_first_space = mayor_info.index(' ')
      title = mayor_info[0..find_first_space-1]
      salary_string_index = mayor_info.index('Salary: $')
      name = mayor_info[find_first_space+4..salary_string_index-3].strip
      dollar_sign_index = mayor_info.index('$')
      period_index = mayor_info.index('.')
      salary = mayor_info[dollar_sign_index+1..period_index-1].strip
      election_info = mayor_info[period_index+2..-1].strip
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
    mayor = PublicEntity.create(name: agency[:name], authority_level: agency[:authority_level], address: agency[:address], description: agency[:description], website: agency[:website], email_address: agency[:email], entity_type: agency[:entity_type], phone: agency[:phone])
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
              chief_name = chief_full[dash_index+3..chief_name_endpoint].strip
              if chief_name.index("Vacant") != nil
                chief_name = nil
                vacant = true
              end
              if salary_string_index != nil
                salary = chief_full[salary_string_index+9..-1].strip
              else
                salary = nil
              end
            else
              chief_title = chief_full[0..-1].strip
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
        website = nokofile.css('#ContentPlaceHolder1_lblAgencyWebAddress').css('a')[0].attributes['href'].value.strip
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
        mission = nokofile.css('#ContentPlaceHolder1_lblMission').text.strip
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
      phone = office[10].strip
      office_type = office[9].strip
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
      street_address = office[12].strip
      zip = office[16].strip
      city = office[14].strip
      state = office[15].strip
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

  desc "Crawl Fire Commissioner"
  task crawl_fire_commissioner: :environment do
    require 'open-uri'
    require 'nokogiri'

    url = 'http://www.nyc.gov/html/fdny/html/general/commissioner/33/biography.shtml'
    page = open(url) { |f| f.read }
    output = Nokogiri::HTML(page)

    name = output.css('h1').children[0].text.strip
    title = output.css('h1').children[2].text.strip
    election_info = "Appointed by the Mayor of the City of New York"
    source = "http://www.nyc.gov/html/fdny/html/general/commissioner/33/biography.shtml"
    source_accessed = Time.now

    fire_commissioner = Chief.create(name: name, title: title, election_info: election_info, source: source, source_accessed: source_accessed)

    fdny = PublicEntity.find_by(name: "Fire Department, New York City (FDNY)")
    fdny.chiefs.push(fire_commissioner)
    mayor = PublicEntity.find_by(name: "Mayor, Office of the (OTM)")
    fdny.superior = mayor
    fdny.superior.save
  end
  
  desc "Crawl Fire Stations"
  task crawl_fire_stations: :environment do
    require 'open-uri'
    require 'json'
    require 'openssl'

    OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE
    url = 'https://nycopendata.socrata.com/api/views/hc8x-tcnd/rows.json?accessType=DOWNLOAD'
    page = open(url) { |f| f.read }
    output = JSON.parse(page)
    data = output['data']

    all_stations = []

    data[1..-1].each do |fire_station|
      name = fire_station[8].strip + " Fire Station"
      street = fire_station[9].strip
      borrough = fire_station[10].strip
      address = street + ', ' + borrough + ', ' + 'New York'
      station = {}
      station = {name: name, address: address }
      all_stations.push(station)
    end  
  
    all_stations.each do |station|
      fdny = PublicEntity.find_by(name: "Fire Department, New York City (FDNY)")
      c = Category.find_or_create_by(name: "Fire Station")
      fire_station = PublicEntity.create(name: station[:name], address: station[:address], authority_level: 'city', description: 'Fire Station.', website: 'www.nyc.gov/fdny', entity_type: 'Fire Station', source: 'NYCOpenData', source_accessed: Time.now, superior: fdny )
      fire_station.categories.push(c)
      sleep(0.5)
    end
  end
  
  desc "Assign First Deputy Mayor as superior to multiple city agencies"
  task assign_first_deputy: :environment do
    first_deputy = PublicEntity.find_by(name: 'First Deputy Mayor')
    nypd = PublicEntity.find_by(name: 'Police Department (NYPD)')
    fdny = PublicEntity.find_by(name: 'Fire Department (FDNY)')
    fdny2 = PublicEntity.find_by(name: 'Fire Department, New York City (FDNY)')
    edu1 = PublicEntity.find_by(name: 'Education, Department of (DOE)')
    edu2 = PublicEntity.find_by(name: 'Education')
    sani = PublicEntity.find_by(name: 'Sanitation (DSNY)')
    oem = PublicEntity.find_by(name: 'Emergency Management NYC Office of (OEM)')
    dot = PublicEntity.find_by(name: 'Transportation (DOT)')
    dob = PublicEntity.find_by(name: 'Buildings (DOB)') 
    ddc = PublicEntity.find_by(name: 'Design And Construction (DDC)')
    ddf = PublicEntity.find_by(name: 'Finance (DOF)')
    dop = PublicEntity.find_by(name: "Parks & Recreation")
    cult = PublicEntity.find_by(name: "Cultural Affairs (DCLA)")
    dep = PublicEntity.find_by(name: "Environmental Protection (DEP)")
    ditt = PublicEntity.find_by(name: "Information Technology and Telecommunications (DOITT)")
    #cto = PublicEntity.find_by(name: "")
    dcas = PublicEntity.find_by(name: "Citywide Administrative Services (DCAS)")
    dris = PublicEntity.find_by(name: "Records & Information Services")
    bic = PublicEntity.find_by(name: "Business Integrity Commission (BIC)")
    tlc = PublicEntity.find_by(name: "Taxi & Limousine Commission (TLC)")
    moo = PublicEntity.find_by(name: "Mayor's Office of Operations")
    mocj = PublicEntity.find_by(name: "Mayor's Office of Criminal Justice (MOCJ)")
    oltps = PublicEntity.find_by(name: "Long-Term Planning & Sustainability, Office of (OLTPS)")
    olr = PublicEntity.find_by(name: "Labor Relations, Office of (OLR)")
    opd = PublicEntity.find_by(name: "Mayor's Office for People With Disabilities (MOPD)")
    oia = PublicEntity.find_by(name: "Mayor's Office of Immigrant Affairs (MOIA)")
    ova = PublicEntity.find_by(name: "Mayor's Office of Veteran's Affairs (MOVA)")
    ocs = PublicEntity.find_by(name: "Contract Services, Mayor's Office of (MOCS)")
    oath = PublicEntity.find_by(name: "Administrative Trials & Hearings, Office of (OATH)")
    oorri = PublicEntity.find_by(name: "Senior Advisor to the Mayor for Recovery, Resiliency, & Infrastructure")
    ooec = PublicEntity.find_by(name: "Environmental Coordination, NYC Office of (OEC)")
    ooer = PublicEntity.find_by(name: "Environmental Remediation, Office of (OER)")
    first_deputy.subordinates.push(nypd, fdny, fdny2, edu1, edu2, sani, oem, dot, dob, ddc, ddf, dop, cult, dep, ditt, dcas, dris, bic, tlc, moo, mocj, oltps, olr, opd, oia, ova, ocs, oath, oorri, ooec, ooer)
    first_deputy.save
  end
  
  desc "Assign Deputy Mayor for Health and Human Services"
  task assign_deputy_hhs: :environment do
    deputy_hhs = PublicEntity.find_by(name: "Deputy Mayor for Health & Human Services")
    dfa = PublicEntity.find_by(name: 'Aging, Department for the (DFTA)')
    dfa2 = PublicEntity.find_by(name: 'Aging (DFTA)')
    acs = PublicEntity.find_by(name: "Children's Services, Administration for (ACS)")
    dhmh = PublicEntity.find_by(name: "Health and Mental Hygiene, Department of (DOHMH)")
    dhmh2 = PublicEntity.find_by(name: "Health & Mental Hygiene (DOHMH)")
    hradss = PublicEntity.find_by(name: "Human Resources Administration, Department of Social Services/ (HRA)")
    hradss2 = PublicEntity.find_by(name: "Human Resources Administration (HRA)")
    dhs = PublicEntity.find_by(name: "Homeless Services (DHS)")
    dhs2 = PublicEntity.find_by(name: "Homeless Services, Department of (DHS)")
    dycd1 = PublicEntity.find_by(name: "Youth and Community Development, Department of (DYCD)")
    dycd2 = PublicEntity.find_by(name: "Youth & Community Development (DYCD)")
    ocdv = PublicEntity.find_by(name: "Mayor's Office to Combat Domestic Violence")
    ocdv2 = PublicEntity.find_by(name: "Domestic Violence, Mayor's Office to Combat (OCDV)")
    ocme = PublicEntity.find_by(name: "Medical Examiner, Office of the Chief (OCME)")
    ocme2 = PublicEntity.find_by(name: "Chief Medical Examiner, NYC Office of (OCME)")
    ofpcidi = PublicEntity.find_by(name: /^Center for Innovation/)
    deputy_hhs.subordinates.push(dfa, dfa2, acs, dhmh, dhmh2, hradss, hradss2, dhs, dhs2, dycd1, dycd2, ocdv, ocdv2, ocme, ocme2, ofpcidi)
    deputy_hhs.save
  end
  
  desc "Assign Deputy Mayor for Housing & Economic Development"
  task assign_deputy_hed: :environment do
    deputy_hed = PublicEntity.find_by(name: "Deputy Mayor for Housing & Economic Development")
    ecd = PublicEntity.find_by(name: "Economic Development Corporation (EDC)")
    ecd2 = PublicEntity.find_by(name: "Economic Development Corporation, NYC (NYCEDC)")
    dhpd = PublicEntity.find_by(name: "Housing Preservation & Development (HPD)")
    dhpd2 = PublicEntity.find_by(name: /^Housing Preservation and Development/)
    nycha = PublicEntity.find_by(name: "Housing Authority, NYC (NYCHA)")
    nycha2 = PublicEntity.find_by(name: "Housing Authority, New York City (NYCHA)")
    dcp = PublicEntity.find_by(name: "City Planning, Department of (DCP)")
    dcp2 = PublicEntity.find_by(name: "City Planning (DCP)")
    cpc = PublicEntity.find_by(name: "City Planning Commission (CPC)")
    mome = PublicEntity.find_by(name: "Media and Entertainment, Mayor's Office of (MOME)")
    mome2 = PublicEntity.find_by(name: "Mayor's Office of Media & Entertainment (MOME)")
    dca = PublicEntity.find_by(name: "Consumer Affairs, Department of (DCA)")
    dca2= PublicEntity.find_by(name: "Consumer Affairs (DCA)")
    pdc = PublicEntity.find_by(name: "Public Design Commission of the City of New York")
    pdc2 = PublicEntity.find_by(name: "Design Commission")
    sbs = PublicEntity.find_by(name: "Small Business Services (SBS)")
    sbs2 = PublicEntity.find_by(name: "Small Business Services (SBS)")
    deputy_hed.subordinates.push(ecd, ecd2, dhpd2, nycha, nycha2, dcp, dcp2, cpc, mome, mome2, dca, dca2, pdc, pdc2, sbs, sbs2 )
    deputy_hed.save
  end

  desc "Assign Deputy Mayor for Strategic Policy Initiatives"
  task assign_deputy_spi: :environment do
    deputy_spi = PublicEntity.find_by(name: "Deputy Mayor for Strategic Policy Initiatives")
    ymi = PublicEntity.find_by(name: "NYC Young Men’s Initiative")
    deputy_spi.subordinates.push(ymi)
    deputy_spi.save
  end

  desc "Assign Counsel to the Mayor"
  task assign_counsel_to_mayor: :environment do
    counsel_to_mayor = PublicEntity.find_by(name: "Counsel to the Mayor")
    chr = PublicEntity.find_by(name: "Human Rights, Commission on (CCHR)")
    #the Commission on Women's Issues
    counsel_to_mayor.subordinates.push(chr)
    counsel_to_mayor.save
  end

  desc "Assign Chief of Staff"
  task assign_chief_of_staff: :environment do
    chief_of_staff = PublicEntity.find_by(name: "Chief of Staff")
    ooa = PublicEntity.find_by(name: "Mayor's Office of Appointments")
    oospce = PublicEntity.find_by(name: "Mayor's Office of Special Projects & Community Events (MOSPCE)")
    oocecm = PublicEntity.find_by(name: "Citywide Event Coordination and Management, Office of (CECM)")
    oocecm2 = PublicEntity.find_by(name: "Office of Citywide Events Coordination & Management")
    nycs = PublicEntity.find_by(name: "NYC Service")
    nycs2 = PublicEntity.find_by(name: "NYC Service (SERVICE)")
    moia = PublicEntity.find_by(name: "Mayor's Office for International Affairs")
    moia2 = PublicEntity.find_by(name: "International Affairs, Mayor's Office for (IA)")
    admin = PublicEntity.find_by(name: "Citywide Administrative Services, Department of (DCAS)")
    admin2 = PublicEntity.find_by(name: "Citywide Administrative Services (DCAS)")
    chief_of_staff.subordinates.push(ooa, oospce, oocecm, oocecm2, nycs, nycs2, moia, moia2, admin, admin2 )
    chief_of_staff.save
  end

  desc "Assign Senior Advisor to the Mayor"
  task assign_senior_advisor: :environment do  
    senior_advisor = PublicEntity.find_by(name: "Senior Advisor to the Mayor")
    press_sec = PublicEntity.find_by(name: "Press Secretary")
    senior_advisor.subordinates.push(press_sec)
    senior_advisor.save
  end

  desc "Assign Office of Intergovernmental Affairs"
  task assign_oiga: :environment do
    oiga = PublicEntity.find_by(name: "Office of Intergovernmental Affairs")
    cau = PublicEntity.find_by(name: "Community Affairs Unit (CAU)")
    cau2 = PublicEntity.find_by(name: "Mayor's Community Affairs Unit (CAU)")
    oiga.subordinates.push(cau, cau2)
    oiga.save
  end
  
  desc "Assign Senior Advisor to the Mayor for RRI"
  task assign_advisor_rri: :environment do
    senior_advisor_rri = PublicEntity.find_by(name: "Senior Advisor to the Mayor for Recovery, Resiliency, & Infrastructure")
    morr = PublicEntity.find_by(name: "Mayor's Office of Recovery & Resiliency (ORR)")
    mos = PublicEntity.find_by(name: "Mayor's Office of Sustainability (OLTPS)")
    mos2 = PublicEntity.find_by(name: "Long-Term Planning & Sustainability, Office of (OLTPS)")
    hro = PublicEntity.find_by(name: "Housing Recovery Office (HRO)")
    hro2 = PublicEntity.find_by(name: "Housing Recovery Operations (HRO)")
    senior_advisor_rri.subordinates.push(morr, mos, mos2, hro, hro2)
    senior_advisor_rri.save
  end
  
  desc "Assign Mayor's Office of Media & Entertainment"
  task assign_mome: :environment do
    mome = PublicEntity.find_by(name: "Mayor's Office of Media & Entertainment (MOME)")
    ooftb = PublicEntity.find_by(name: "Office of Film Theatre & Broadcasting")
    nycm = PublicEntity.find_by(name: "NYC Media")
    mome.subordinates.push(ooftb, nycm)
    mome.save
  end
  
  desc "Remove duplicate Governor of NYS entry"
  task remove_duplicate_governor: :environment do
    governor_duplicate = PublicEntity.find_by(name: 'Office of the Governor')
    governor_duplicate.delete!
  end
  
  desc "Merge and remove City Council Duplicate"
  task remove_duplicate_city_council: :environment do
    city_council_1 = PublicEntity.find_by(name: "City Council (NYCC)")
    city_council_2 = PublicEntity.find_by(name: "City Council, New York")
    city_council_1.superior = nil
    city_council_1.website = city_council_2.website
    cc_categories = city_council_2.categories
    city_council_1.categories.push(cc_categories)
    city_council_1.description = city_council_1.description + " " + city_council_2.description
    city_council_1.source = "NYC.gov, NYC Greenbook"
    city_council_1.save
    city_council_2.delete
  end
  
  desc "Crawl City Council"
  task crawl_city_council: :environment do
    require 'open-uri'
    require 'Nokogiri'
    city_council_1 = PublicEntity.find_by(name: "City Council (NYCC)")
    #source
    source = "http://council.nyc.gov/"
    source_accessed = Time.now
    
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
    #initialize empty entity hash
    council_member_offices = {}
    #initialize empty array for all offices
    all_council_member_offices = []
    
    all_links.each do |member_page_link|
      member_page_content = open(member_page_link) { |f| f.read }
      parsed_page_content = Nokogiri::HTML(member_page_content)
      top_box = parsed_page_content.css('td').css('.inside_top_text')
      #council member info
      if top_box[0] != nil
        council_member_name = top_box[0].children.css('h1').text.strip
        council_member_desc = top_box[0].children[2].text.strip
        if council_member_desc.empty? == false
          if council_member_desc.index("Council Speaker") != nil
            title = "Council Speaker"
          else
            title = "Council Member"
          end
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
      chief = { name: council_member_name, title: title, salary: "112,500", election_info: "Elected at the general election held November 5, 2013", source:source, source_accessed: source_accessed, image_link:image_link, political_party:political_party }
  
      #contact info
      contact_box = parsed_page_content.css('td').css('.nav_section')
      contact_info_section = contact_box.children[0].children[3].children[1].children
      district_office_address = contact_info_section[3].text.strip
      d_o_a_stripped = district_office_address.gsub("\n", " ")
      district_office_phone = contact_info_section[9].text.strip
      district_office_fax = contact_info_section[15].text.strip
      legislative_office_address = contact_info_section[21].text.strip
      legislative_office_phone = contact_info_section[27].text.strip
      legislative_office_fax = contact_info_section[33].text.strip
      email_string = contact_info_section.css('a')[0]['href'][7..-1]
      description = "Members of the New York City Council are elected political officials who, together as the Council, monitor city agencies, make land use decision, and approve the city budget."
      if district == nil
        office_name = "City Council Member Office"
      else
        office_name = "Office of the City Council Member for District " + district.to_s
      end
      council_member_office = { name: office_name, authority_level: "city", address: d_o_a_stripped, description: description, website:member_page_link, email_address: email_string, phone: district_office_phone, chief: chief }
      all_council_member_offices.push(council_member_office)
    end

    all_council_member_offices.each do |office|
      new_council_office = PublicEntity.create(name: office[:name], authority_level: office[:authority_level], address: office[:address], description: office[:description], website: office[:website], email_address: office[:email_address], entity_type:"city executive", superior: city_council_1, phone: office[:phone], source:"http://council.nyc.gov/", source_accessed: Time.now )
      sleep(0.5)
      #chief_info = council_member_office[:chief]
      new_council_member = Chief.create(name: office[:chief][:name], title: office[:chief][:title], salary: office[:chief][:salary], election_info: office[:chief][:election_info], image_link: office[:chief][:image_link], political_party: office[:chief][:political_party],source:source, source:"http://council.nyc.gov/", source_accessed: Time.now )
      sleep(0.5)
      new_council_office.chiefs.push(new_council_member)
      category = Category.find_or_create_by(name: "Political Officer")
      new_council_office.categories.push(category)
    end
  end
  
  desc "Update City Council Member blanks"
  task update_council_members: :environment do
    cdeutsch_office = PublicEntity.find_by(email_address: "cdeutsch@council.nyc.gov")
    cdeutsch_office.name = "Office of the City Council Member for District 48"
    cdeutsch_office.save
    dmiller_office = PublicEntity.find_by(email_address: "District27@council.nyc.gov")
    dmiller_office.name = "Office of the City Council Member for District 27"
    dmiller_office.save
    district_23 = PublicEntity.find_by(website: "http://council.nyc.gov/d23/html/members/home.shtml")
    district_23.name = "Office of the City Council Member for District 23"
    district_23.save
    hrosenthal_office = PublicEntity.find_by(website: "http://council.nyc.gov/d6/html/members/home.shtml")
    hrosenthal_office.name = "Office of the City Council Member for District 6"
    hrosenthal_office.save
    hrosenthal = hrosenthal_office.chiefs[0]
    hrosenthal.name = "Helen Rosenthal"
    hrosenthal.title = "Council Member"
    hrosenthal.political_party = "Democrat"
    hrosenthal.save
  end
  
  desc "Remove duplicate Comptroller"
  task remove_duplicate_comptroller: :environment do
    comptroller_1 = PublicEntity.find_by(name: "Comptroller")
    comptroller_2 = PublicEntity.find_by(name: "Comptroller (COMP)")
    desc_length = comptroller_1.description.length
    desc_stop_point = (desc_length / 2) - 1
    comptroller_1.description = comptroller_1.description[0..desc_stop_point] + ' ' + comptroller_2.description
    comptroller_1.superior = nil
    comptroller_1.save
    comptroller_2.delete
    ctg_civic_services = Category.find_or_create_by(name: "Civic Services")
    ctg_political_officer = Category.find_or_create_by(name: "Political Officer")
    comptroller_1.categories.push(ctg_civic_services, ctg_political_officer)
  end
  
  desc "Remove duplicate Public Advocate"
  task remove_duplicate_pub_adv: :environment do
    pub_adv_1 = PublicEntity.find_by(name: "Public Advocate for the City of New York")
    pub_adv_2 = PublicEntity.find_by(name: "Public Advocate (PUB ADV)")
    desc_length = pub_adv_1.description.length
    desc_stop_point = (desc_length / 2 ) - 1
    pub_adv_1.description = pub_adv_2.description + " " + pub_adv_1.description[0..desc_stop_point]
    pub_adv_1.superior = nil
    pub_adv_1.save
    pub_adv_2.delete
    ctg_civic_services = Category.find_or_create_by(name: "Civic Services")
    ctg_political_officer = Category.find_or_create_by(name: "Political Officer")
    pub_adv_1.categories.push(ctg_civic_services, ctg_political_officer)
  end
end
