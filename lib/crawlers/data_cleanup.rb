#First Deputy
first_deputy = PublicEntity.find_by(name: 'First Deputy Mayor')
nypd = PublicEntity.find_by(name: 'Police Department (NYPD)')
fdny = PublicEntity.find_by(name: 'Fire Department (FDNY)')
fdny2 = PublicEntity.find_by(name: 'Fire Department, New York City (FDNY)')
edu1 = PublicEntity.find_by(name: 'Education, Department of (DOE)')
edu2 = PublicEntity.find_by(name: 'Education')
sani = PublicEntity.find_by(name: 'Sanitation (DSNY)')
oem = PublicEntity.find_by(name: 'Emergency Management, Office of (OEM)')
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
# add the Chief Technology Officer

#Deputy Mayor for Health & Human Services
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
ofpcidi = PublicEntity.find_by(name: "Center for Innovation through Data Intelligence (CIDI)")
deputy_hhs.subordinates.push(dfa, dfa2, acs, dhmh, dhmh2, hradss, hradss2, dhs, dh2s, dycd1, dycd2, ocdv1, ocdv2, ocme, ocme2, ofpcidi)
deputy_hhs.save

#Deputy Mayor for Housing & Economic Development
deputy_hed = PublicEntity.find_by(name: "Deputy Mayor for Housing & Economic Development")
ecd = PublicEntity.find_by(name: "Economic Development Corporation (EDC)")
ecd2 = PublicEntity.find_by(name: "Economic Development Corporation, NYC (NYCEDC)")
dhpd = PublicEntity.find_by(name: "Housing Preservation & Development (HPD)")
dhpd2 = PublicEntity.find_by(name: "Housing Preservation and Development, Department of (HPD)")
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


#Deputy Mayor for Strategic Policy Initiatives
deputy_spi = PublicEntity.find_by(name: "Deputy Mayor for Strategic Policy Initiatives")
ymi = PublicEntity.find_by(name: "NYC Young Men’s Initiative")
deputy_spi.subordinates.push(ymi)
deputy_spi.save

#Counsel to the Mayor
counsel_to_mayor = PublicEntity.find_by(name: "Counsel to the Mayor")
chr = PublicEntity.find_by(name: "Human Rights, Commission on (CCHR)")
#the Commission on Women's Issues 

#Chief of Staff
counsel_to_mayor = PublicEntity.find_by(name: "Chief of Staff")
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
counsel_to_mayor.subordinates.push(ooa, oospce, oocecm, oocecm2, nycs, nycs2, moia, moia2, admin, admin2 )
counsel_to_mayor.save

#Senior Advisor to the Mayor
senior_advisor = PublicEntity.find_by(name: "Senior Advisor to the Mayor")
presssec = PublicEntity.find_by(name: "Press Secretary")
#the Mayor's Office of Speechwriting
#the Mayor's Office of Research and Analysis
#Mayor's Office of Visual Communications, formerly known as the Mayor's Office of Photography
#The Senior Advisor also oversees the city's Office of Digital Engagement which includes digital engagement, content creation and social media strategies.


#Office of Intergovernmental Affairs
oiga = PublicEntity.find_by("Office of Intergovernmental Affairs")
cau = PublicEntity.find_by("Community Affairs Unit (CAU)")
cau2 = PublicEntity.find_by("Mayor's Community Affairs Unit (CAU)")
oiga.subordinates.push(cau, cau2)
oiga.save

#Mayor's Office of Operations
#The Office of Operations' Performance Management Group also monitors the performance of all City agencies, holding each agency accountable for providing high quality services and making data about the city's performance readily available to the public.
#The Audit Services Unit oversees agency activity with respect to audits conducted by governmental and non-governmental entities, including the City Comptroller and the State and Federal governments.
#In addition, the Office of Operations oversees 311, the City's one-stop hotline and online shop for information about City government
#the Office of Data Analytics (MODA)
#the City's civic intelligence center, allowing the City to aggregate and analyze data from across City agencies
#and the Center for Economic Opportunity which fights the cycle of poverty in New York City through innovative programs that build human capital and improve financial security.

#Mayor's Office of Contract Services (MOCS)
mocs = PublicEntity.find_by(name: "Mayor's Office of Contract Services (MOCS)")
#provides online access to public contract information through its Public Access Center
#and oversees the Central Insurance Program for nonprofit contractors

#Senior Advisor to the Mayor for Recovery, Resiliency, & Infrastructure
senior_advisor_rri = PublicEntity.find_by(name: "Senior Advisor to the Mayor for Recovery, Resiliency, & Infrastructure")
morr = PublicEntity.find_by(name: "Mayor's Office of Recovery & Resiliency (ORR)")
mos = PublicEntity.find_by(name: "Mayor's Office of Sustainability (OLTPS)")
mos2 = PublicEntity.find_by(name: "Long-Term Planning & Sustainability, Office of (OLTPS)")
hro = PublicEntity.find_by(name: "Housing Recovery Office (HRO)")
hro2 = PublicEntity.find_by(name: "Housing Recovery Operations (HRO)")
senior_advisor_rri.subordinates.push(morr, mos, mos2, hro, hro2)
senior_advisor_rri.save

#Mayor's Office for People With Disabilities (MOPD)
#The Commissioner co-chairs the City's Americans with Disabilities Act Task Force
#the Pedestrian Ramp Committee and serves as a statutory member to the 
#Transportation Disabled Committee.

#Mayor's Office for International Affairs
#and administrating the City of New York/US Department of State Diplomatic and Consular Parking program.

#Mayor's Office of Media & Entertainment (MOME)
mome = PublicEntity.find_by(name: "Mayor's Office of Media & Entertainment (MOME)")
ooftb = PublicEntity.find_by(name: "Office of Film Theatre & Broadcasting")
nycm = PublicEntity.find_by(name: "NYC Media")
mome.subordinates.push(ooftb, nycm)

#Mayor's Office of Criminal Justice (MOCJ)
#The Mayor's Office of Criminal Justice houses the Office of the Criminal Justice Coordinator (CJC)

#Duplicates
governor_duplicate = PublicEntity.find_by(name: 'Office of the Governor')
governor_duplicate.delete
governor_duplicate.save