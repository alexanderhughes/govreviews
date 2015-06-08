# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Category for executives
c = Category.find_or_create_by(name: 'Political Officer')
#State Executive Offices
pe = PublicEntity.create(name: "The Governor of New York", authority_level: "state", address: "Governor of New York State, NYS State Capitol Building, State Street and Washington Ave, Albany, NY, 12224", description: "Governor of NYS", website: "https://www.governor.ny.gov", entity_type: "state executive")
pe.categories.push(c)

#City Executive Offices
pe = PublicEntity.create(name: "The Mayor of New York City", authority_level: "city", address: "Mayor of New York City, New York City Hall, City Hall Park, New York, NY, 10007", description: "Mayor of New York City", website: "http://www1.nyc.gov/office-of-the-mayor/", entity_type: "city executive")
pe.categories.push(c)
pe = PublicEntity.create(name: "The New York City Public Advocate", authority_level: "city", address: "Public Advocate for the City of New York, 1 Centre St #1500, New York, NY, 10007", description: "Public Advocate for the City of New York", website: "http://pubadvocate.nyc.gov/", entity_type: "city executive")
pe.categories.push(c)
pe = PublicEntity.create(name: "The New York City Comptroller", authority_level: "city", address: "New York City Comptroller, 1 Centre St #530, New York, NY, 10007", description: "New York City Comptroller", website: "http://comptroller.nyc.gov/", entity_type: "city executive")
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