# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Category for executives
c = Category.find_or_create_by(name: 'Political Officer')
c_statewide_officials = Category.find_or_create_by(name: 'Statewide Elected Officials')
#State Executive Offices
pe = PublicEntity.create(name: "Office of the Governor of New York", authority_level: "state", address: "NYS State Capitol Building, State Street and Washington Ave, Albany, NY, 12224", description: "Governor of NYS", website: "https://www.governor.ny.gov", entity_type: "state executive")
pe.categories.push(c, c_statewide_officials)
cuomo = Chief.create(name: "Andrew M. Cuomo", title: "Governor of the State of New York", salary: "179,000", election_info: "Elected at the general election held November 4, 2014, for a term of four years, expiring December 31 2018.")
pe.chiefs.push(cuomo)

#City Executive Offices
pe = PublicEntity.create(name: "Mayor of New York City", authority_level: "city", address: "New York City Hall, City Hall Park, New York, NY, 10007", description: "Mayor of New York City", website: "http://www1.nyc.gov/office-of-the-mayor/", entity_type: "city executive")
pe.categories.push(c)
pe = PublicEntity.create(name: "New York City Public Advocate", authority_level: "city", address: "1 Centre St #1500, New York, NY, 10007", description: "Public Advocate for the City of New York", website: "http://pubadvocate.nyc.gov/", entity_type: "city executive")
pe.categories.push(c)
pe = PublicEntity.create(name: "New York City Comptroller", authority_level: "city", address: "1 Centre St #530, New York, NY, 10007", description: "New York City Comptroller", website: "http://comptroller.nyc.gov/", entity_type: "city executive")
pe.categories.push(c)


#"name"
#"authority_level"
#"address"
#"description"
#"website"
#"created_at"
#"updated_at"
#"entity_type"
#"superior_id"
#"chief_id"
#"geotag"
