mta_board = PublicEntity.find_or_create_by(name: "MTA Board", authority_level: "state", address: "2 Broadway, New York, NY 10004", description: "A public-benefit corporation chartered by the New York State Legislature in 1968, the MTA is governed by a 17-member Board. Members are nominated by the Governor, with four recommended by New York City's mayor and one each by the county executives of Nassau, Suffolk, Westchester, Dutchess, Orange, Rockland, and Putnam counties. (Members representing the latter four cast one collective vote.) All Board members are confirmed by the New York State Senate. Terms are six years. The Board comprises the following standing committees: Audit Committee; Bridges & Tunnel Committee; CPOC Committee; Finance Committee; Metro-North Committee; LIRR Committee; NYCT & Bus Committee; Governance Committee; Diversity Committee; Safety Committee.", website: "www.mta.info", entity_type: "public-benefit corporation", phone: "(646) 252-7006", source:"www.mta.info", source_accessed: Time.now )
catg_transportation = Categories.find(name: "Transportation" )
catg_local_and_reg = Categories.find(name: "Local and Regional Authorities")
mta_board.categories.push(catg_transportation, catg_local_and_reg)

#crawl board members
require 'open-uri'
require 'Nokogiri'

url = "http://web.mta.info/mta/leadership/board.htm"
content = open(url) { |f| f.read }
mta_content = Nokogiri::HTML(content)

mta_board_table = mta_content.css('table')[1].css('tr')

mta_board_table[1..20].each do |member|
  name = member.css('a').text.strip
  if member.children[1].children[2] != nil
    title = member.children[1].children[2].text.strip
  else
    title = "MTA Board Member"
  end
  bio_link = member.css('a')[0]['href'].strip
  full_bio_link = "http://web.mta.info/mta/leadership/" + bio_link
  recommended_by = member.css('td')[1].text.strip
  date_first_confirmed = member.css('td')[2].text.strip
  term_expires = member.css('td')[3].text.strip
  appointment_info = "Recommended by the " + recommended_by + ", first confirmed by the NY State Senate on " + date_first_confirmed + ". Term expires " + term_expires + "."
  mta_board_member = Chief.create(name: name, title: title, election_info: appointment_info, source:"www.mta.info", source_accessed: Time.now, image_link: full_image_link )
  mta_board.chiefs.push(mta_board_member)
end

mta = PublicEntity.create(name: "Metropolitan Transportation Authority of the State of New York", authority_level: "state", address: "2 Broadway, New York, NY 10004", description: "The Metropolitan Transportation Authority (“MTA”), a public benefit corporation of the State of New York, has the responsibility for developing and implementing a unified mass transportation policy for The City of New York (the “City”) and Dutchess, Nassau, Orange, Putnam, Rockland, Suffolk and Westchester counties (collectively with the City, the “Transportation District”). MTA carries out these responsibilities directly and through its subsidiaries and affiliates. The following are subsidiaries of MTA: The Long Island Rail Road Company (“LIRR”), Metro-North Commuter Railroad Company (“MNCRC”), Staten Island Rapid Transit Operating Authority (“SIRTOA”), and Metropolitan Suburban Bus Authority (“MSBA”). The following are affiliates of MTA: Triborough Bridge and Tunnel Authority (“TBTA”), and New York City Transit Authority (the “Transit Authority”), and its subsidiary, the Manhattan and Bronx Surface Transit Operating Authority (“MaBSTOA”). MTA consists of a Chairman and 16 other voting Members, two non-voting Members and four alternate non-voting Members, all of whom are appointed by the Governor with the advice and consent of the Senate. The four voting Members required to be residents of the counties of Dutchess, Orange, Putnam and Rockland, respectively, cast only one collective vote. The other voting Members, including the Chairman, cast one vote each. Members of MTA are, ex officio, the Members or Directors of the other Related Entities.", website: "www.mta.info", entity_type: "Public-Benefit Corporation", phone: "(646) 252-7006", source:"www.mta.info", source_accessed: Time.now )
mta.categories.push(catg_transportation, catg_local_and_reg)
#crawl management team
chief_of_staff = Chief.create(name: "Donna Evans", title: "Chief of Staff", image_link: "http://web.mta.info/mta/leadership/images/evans.jpg" )
c1 = Chief.create(name: "Margaret M. Connor", title: "Senior Director, Human Resources/Retirement Programs", image_link: "http://web.mta.info/mta/leadership/images/connor.jpg", source: "www.mta.info", source_accessed = Time.now )
c2 = Chief.create(name: "Raymond Diaz", title: "Director of Security", image_link: "http://web.mta.info/mta/leadership/images/diaz80.jpg", source: "www.mta.info", source_accessed = Time.now )
c3 = Chief.create(name: "Robert E. Foran", title: "Chief Financial Officer", image_link: "http://web.mta.info/mta/leadership/images/foran.jpg", source: "www.mta.info", source_accessed = Time.now )
c4 = Chief.create(name: "Michael J. Fucilli", title: "Auditor General", image_link: "http://web.mta.info/mta/leadership/images/fucilli_90.jpg", source: "www.mta.info", source_accessed = Time.now )
c5 = Chief.create(name: "Michael J. Garner", title: "Chief Diversity Officer", image_link: "http://web.mta.info/mta/leadership/images/garner.jpg", source: "www.mta.info", source_accessed = Time.now )
c6 = Chief.create(name: "Wael Hibri", title: "Senior Director, Business Service Center", image_link: "http://web.mta.info/mta/leadership/images/hibri.jpg", source: "www.mta.info", source_accessed = Time.now )
c7 = Chief.create(name: "David L. Mayer", title: "Chief Safety Officer", image_link: "http://web.mta.info/mta/leadership/images/mayer.jpg", source: "www.mta.info", source_accessed = Time.now )
c8 = Chief.create(name: "Anita Miller", title: "Chief Employee Relations and Administrative Officer", image_link: "http://web.mta.info/mta/leadership/images/Miller.jpg", source: "www.mta.info", source_accessed = Time.now )
c9 = Chief.create(name: "Jerome F. Page", title: "General Counsel", image_link: "http://web.mta.info/mta/leadership/images/page_j.jpg", source: "www.mta.info", source_accessed = Time.now )
c10 = Chief.create(name: "William Wheeler", title: "Director of Special Project Development & Planning", image_link: "http://web.mta.info/mta/leadership/images/wheeler_80.jpg", source: "www.mta.info", source_accessed = Time.now )
mta.chiefs.push(chief_of_staff, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10 )

mta_nyct = PublicEntity.create(name: "MTA New York City Transit", authority_level: "state", address: "2 Broadway, New York, NY 10014", description: "NYC Transit keeps New York moving 24 hours a day, seven days a week, as its subways speed through underground tunnels and elevated structures in the boroughs of Manhattan, Brooklyn, Queens, and the Bronx. On Staten Island, the MTA Staten Island Railway links 22 communities. Motor-bus service on the streets of Manhattan began in 1905. Today, NYC Transit's buses run in all five boroughs, on more than 200 local and 30 express routes. They account for 80 percent of the city's surface mass transportation. NYC Transit also administers paratransit service throughout New York City to provide transportation options for people with disabilities. MetroCard®, the MTA's automated fare collection medium, is accepted on all New York City Transit subway stations and on buses. It can also be used on MTA Bus, Nassau Inter-county Express (NICE) bus, and on the PATH system (operated by the Port Authority of New York and New Jersey), a subway linking New York and New Jersey. Among NYC Transit's capital projects are additional new subway cars and a state-of-the-art \"communication-based” signal system to replace mechanical signals dating to 1904.", website: "www.mta.info", entity_type: "Public-Benefit Corporation", phone: "(718) 694-1000", source:"www.mta.info", source_accessed: Time.now)
mta_lirr = PublicEntity.create(name: "MTA Long Island Rail Road", authority_level: "state", address: "Jamaica Station, Jamaica, NY 11435", description: "The Long Island Rail Road is both the largest commuter railroad and the oldest railroad in America operating under its original name. Chartered in 1834, it extends from three major New York City terminals — Penn Station, Flatbush Avenue, and Hunterspoint Avenue — through a major transfer hub at Jamaica to the easternmost tip of Long Island.", website: "www.mta.info", entity_type: "Public-Benefit Corporation", phone: "718-217-5477", source:"www.mta.info", source_accessed: Time.now)
mta_mnr = PublicEntity.create(name: "MTA Metro-North Railroad", authority_level: "state", address: "347 Madison Avenue, New York, NY 10017", description: "Metro-North Railroad is second largest commuter railroad in the nation. Its main lines — the Hudson, Harlem, and New Haven — run northward out of Grand Central Terminal, a Beaux-Arts Manhattan landmark, into suburban New York and Connecticut. Grand Central has been completely restored and redeveloped as a retail hub — a destination in its own right. West of the Hudson River, Metro-North's Port Jervis and Pascack Valley lines operate from NJ Transit's Hoboken terminal and provide service to Rockland and Orange counties. With the opening of Secaucus Junction, West-of-Hudson customers can now transfer to trains that will carry them directly to Newark or New York's Penn Station, and the Pascack Valley Line has introduced weekend service for the first time in 60 years.", website: "www.mta.info", entity_type: "Public-Benefit Corporation", phone: "(212) 532-4900", source:"www.mta.info", source_accessed: Time.now)
mta_bat = PublicEntity.create(name: "MTA Bridges and Tunnels", authority_level: "state", address: "Randalls Island, New York, NY 10035", description: "Created in 1933 by Robert Moses, MTA Bridges and Tunnels serves more than 800,000 vehicles each weekday — nearly 290 million vehicles each year — and carries more traffic than any other bridge and tunnel authority in the nation. Surplus revenues from the authority's tolls help support MTA transit services. MTA Bridges and Tunnels bridges are the Robert F. Kennedy, Throgs Neck, Verrazano-Narrows, Bronx-Whitestone, Henry Hudson, Marine Parkway-Gil Hodges Memorial, and Cross Bay Veterans Memorial; its tunnels are the Hugh L. Carey and Queens Midtown. All are within New York City, and all accept payment by E-ZPass, an electronic toll collection system that is moving traffic through MTA Bridges and Tunnels toll plazas faster and more efficiently. Eighty-four percent of the vehicles that use MTA Bridges and Tunnels crossings on weekdays now use E-ZPass.", website: "www.mta.info", entity_type: "Public-Benefit Corporation", phone: "(212) 360-3000", source:"www.mta.info", source_accessed: Time.now) 
mta_bc = PublicEntity.create(name: "MTA Bus Company", authority_level: "state", address: "2 Broadyway, New York, NY 10004", description: "The MTA Bus Company was created in September 2004 to assume the operations of seven bus companies that operated under franchises granted by the New York City Department of Transportation. The takeover of the lines began in 2005 and was completed early in 2006. MTA Bus is responsible for both the local and express bus operations of the seven companies, consolidating operations, maintaining current buses, and purchasing new buses to replace the aging fleet currently in service. MTA Bus operates 47 local routes in the Bronx, Brooklyn, and Queens, and 35 express bus routes between Manhattan and the Bronx, Brooklyn, or Queens. It has a fleet of more than 1,200 buses, the 11th largest bus fleet in the United States and Canada.", website: "www.mta.info", entity_type: "Public-Benefit Corporation", phone: "(646) 252-5872", source:"www.mta.info", source_accessed: Time.now) 
mta_bsc = PublicEntity.create(name: "MTA Business Service Center", authority_level: "state", address: "333 W. 34th Street, 9th Floor, New York, NY 10001", website: "https://www.mtabsc.info/", entity_type: "Public-Benefit Corporation", phone: "(646) 376-0677", source:"www.mta.info", source_accessed: Time.now)
mta_cc = PublicEntity.create(name: "MTA Capital Construction Company", authority_level: "state", address: "2 Broadway, New York, NY 10014" description: "MTA Capital Construction Company was formed in July 2003 to serve as the construction management company for MTA expansion projects, downtown mobility projects, and MTA-wide security projects. Capital Construction has a core group of employees and draws on the expertise of construction and other professionals at the MTA agencies as well as on the nation's leading construction consulting firms. It recently completed the award-winning Fulton Center project and will open the 7 line extension later this year.", website: "www.mta.info", entity_type: "Public-Benefit Corporation", phone: "(646) 252-4277", source:"www.mta.info", source_accessed: Time.now)
#create and crawl Permanent Citizens Advisory Committee to the MTA
pcac_mta = PublicEntity.create(name: "Permanent Citizens Advisory Committee to the MTA", authority_level: "state", address: "2 Broadway, 16th Fl., New York, NY, 10004", phone: "(212) 878-7087", website: "www.pcac.org", email_address: "mail@pcac.org", description: "The coordinating body and funding mechanism for the three riders councils created by the New York State Legislature in 1981: the Long Island Rail Road Commuter Council (LIRRCC); the Metro-North Railroad Commuter Council (NYCTRC); and the New York City Transit Riders Council (NYCTRC). The PCAC and Councils serve to give users of MTA public transportation services a voice in the formulation and implementation of MTA policy and to hold the MTA Board and management accountable to riders." source: "NYC Greenbook", source_accessed: Time.now)

mta_nyct.categories.push(catg_transportation)
mta_lirr.categories.push(catg_transportation)
mta_mnr.categories.push(catg_transportation)
mta_bat.categories.push(catg_transportation)
mta_bc.categories.push(catg_transportation)
mta_bsc.categories.push(catg_transportation)
mta_cc.categories.push(catg_transportation)
pcac_mta.categories.push(catg_transportation)

#scrape Greenbok for NYCTA Chiefs
url = "http://a856-gbol.nyc.gov/gbolwebsite/323.html"
content = open(url) { |f| f.read }
mta_greenbook = Nokogiri::HTML(content)

nycta_greenbook = mta_greenbook.css('table')[5]
nycta_greenbook_chiefs = nycta_greenbook.css('tr')

nycta_greenbook_chiefs[5..16].each do |chief|
  title_and_name = chief.css('p')[0].text.strip
  dash_index = title_and_name.index('-')
  title = title_and_name[0..dash_index-2]
  name = title_and_name[dash_index+3..-1].gsub("  "," ")
  phone = chief.css('p')[2].text.strip
  new_chief = Chief.create(name: name, title: title, phone: phone, source: "NYC Greenbook", source_accessed: Time.now )
  nycta = PublicEntity.find_by(name: "MTA New York City Transit")
  nycta.chiefs.push(new_chief)
end

lirr_greenbook = mta_greenbook.css('table')[6]
lirr_greenbook_chiefs = lirr_greenbook.css('tr')

lirr_greenbook_chiefs[4..17].each do |chief|
  title_and_name = chief.css('p')[0].text.strip
  dash_index = title_and_name.index('-')
  title = title_and_name[0..dash_index-2]
  name = title_and_name[dash_index+3..-1]
  name = name.gsub("  ", " ")
  phone = chief.css('p')[2].text.strip
  new_chief = Chief.create(name: name, title: title, phone: phone, source: "NYC Greenbook", source_accessed: Time.now )
  lirr = PublicEntity.find_by(name: "MTA Long Island Rail Road")
  lirr.chiefs.push(new_chief)
end

metro_north_greenbook = mta_greenbook.css('table')[7]
metro_north_greenbook_chiefs = metro_north_greenbook.css('tr')

metro_north_greenbook_chiefs[5..16].each do |chief|
  title_and_name = chief.css('p')[0].text.strip
  if title_and_name.index("Metro-North") != nil
    title = "Metro-North President"
    title_index = title_and_name.index(title)
    name = title_and_name[title_index+25..-1]
    name = name.gsub("  ", " ")
  else
    dash_index = title_and_name.index('-')
    title = title_and_name[0..dash_index-2]
    name = title_and_name[dash_index+3..-1]
    name = name.gsub("  ", " ")
  end
  phone = chief.css('p')[2].text.strip
  new_chief = Chief.create(name: name, title: title, phone: phone, source: "NYC Greenbook", source_accessed: Time.now )
  metro_north = PublicEntity.find_by(name: "MTA Metro-North Railroad")
  metro_north.chiefs.push(new_chief)
end

bridges_tunnels_greenbook = mta_greenbook.css('table')[8]
bridges_tunnels_greenbook_chiefs = bridges_tunnels_greenbook.css('tr')

bridges_tunnels_greenbook_chiefs[5..16].each do |chief|
  title_and_name = chief.css('p')[0].text.strip
  dash_index = title_and_name.index('-')
  title = title_and_name[0..dash_index-2]
  name = title_and_name[dash_index+3..-1].gsub("  ", " ")
  phone = chief.css('p')[2].text.strip
  new_chief = Chief.create(name: name, title: title, phone: phone, source: "NYC Greenbook", source_accessed: Time.now )
  b_and_t = PublicEntity.find_by(name: "MTA Bridges and Tunnels")
  b_and_t.chiefs.push(new_chief)
end

pcac_greenbook = mta_greenbook.css('table')[19]
pcac_greenbook_chiefs = pcac_greenbook.css('tr')

pcac_greenbook_chiefs[6..12].each do |chief|
  title_and_name = chief.text.strip
  dash_index = title_and_name.index('-')
  title = title_and_name[0..dash_index-2]
  name = title_and_name[dash_index+3..-1].gsub("  ", " ")
  new_chief = Chief.create(name: name, title: title, source: "NYC Greenbook", source_accessed: Time.now )
  pcac = PublicEntity.find_by(name: "Permanent Citizens Advisory Committee to the MTA")
  pcac.chiefs.push(new_chief)
end

cap_construction_greenbook = mta_greenbook.css('table')[22]
cap_construction_greenbook_chiefs = cap_construction_greenbook.css('tr')

cap_construction_greenbook_chiefs[5..17].each do |chief|
  title_and_name = chief.css('p')[0].text.strip
  dash_index = title_and_name.index('-')
  title = title_and_name[0..dash_index-2]
  name = title_and_name[dash_index+3..-1]
  name = name.gsub("  ", " ")
  phone = chief.css('p')[2].text.strip
  new_chief = Chief.create(name: name, title: title, source: "NYC Greenbook", source_accessed: Time.now )
  cc = PublicEntity.find_by(name: "MTA Capital Construction Company")
  cc.chiefs.push(new_chief)
end

bus_co_greenbook = mta_greenbook.css('table')[23]
bus_co_greenbook_chiefs = bus_co_greenbook.css('tr')

bus_co_greenbook_chiefs[5..14].each do |chief|
  title_and_name = chief.css('p')[0].text.strip
  dash_index = title_and_name.index('-')
  title = title_and_name[0..dash_index-2]
  name = title_and_name[dash_index+3..-1].gsub("  ", " ")
  phone = chief.css('p')[2].text.strip
  new_chief = Chief.create(name: name, title: title, source: "NYC Greenbook", source_accessed: Time.now )
  bus_co = PublicEntity.find_by(name: "MTA Bus Company")
  bus_co.chiefs.push(new_chief)
end