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
