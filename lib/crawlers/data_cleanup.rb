#First Deputy
first_deputy = PublicEntity.find_by(name: 'First Deputy Mayor')
nypd = PublicEntity.find_by(name: 'Fire Department (FDNY)')
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

first_deputy.subordinates.push(nypd, sani, oem, dot, dob, ddc, ddf, dop, cult, dep, ditt, dcas, dris, bic, tlc, moo, mocj, oltps, olr, opd, oia, ova, ocs, oath, oorri, ooec, ooer)
first_deputy.save
# add the Chief Technology Officer

#Deputy Mayor for Health & Human Services
#The Deputy Mayor for Health and Human Services oversees and coordinates the operations of the Department for the Aging, Administration for Children's Services, Department of Health and Mental Hygiene, Human Resources Administration/Department of Social Services, the Department of Homeless Services, the Department of Youth & Community Development, the Office to Combat Domestic Violence, the Office of the Chief Medical Examiner, and the Office of Food Policy and Center for Innovation through Data Intelligence. The Deputy Mayor for Health and Human Services also serves as the liaison to the Health and Hospitals Corporation and sits on its board.

#Deputy Mayor for Housing & Economic Development
#The Deputy Mayor for Housing and Economic Development oversees and coordinates the operations of the Economic Development Corporation, Department of Housing Preservation and Development, New York City Housing Authority, Department of City Planning, Mayor's Office of Media and Entertainment, Department of Consumer Affairs, the Public Design Commission, and the Department of Small Business Services. The Deputy Mayor also serves as a liaison with city, state and federal agencies and other agencies responsible for the City's economic development and infrastructure, including: NYC & Company, Lower Manhattan Development Corporation, Housing Development Corporation, Rent Guidelines Board, Hudson River Park Trust, The Trust for Governor's Island, Landmarks Preservation Commission, Board of Standards and Appeals, and Brooklyn Navy Yard.

#Deputy Mayor for Strategic Policy Initiatives
#The Deputy Mayor for Strategic Policy Initiatives directs many of the administration's signature initiatives requiring major interagency collaboration including the launch of pre-Kindergarten education for every 4-year-old, expansion of middle school afterschool programs, the development of 100 community schools, and Chair of the New York City Children's Cabinet. The Children's Cabinet is a multi-agency initiative created to bolster communication and coordination among city agencies and will provide a space for multiple city agencies to identify and analyze individual and common areas of work that impact child safety and well-being. The Deputy Mayor for Strategic Policy Initiatives also oversees the Young Men's Initiative.
#Deputy Mayor for Strategic Policy Initiatives - Richard Buery Salary: $222,182
#Chief of Staff - Alexis Confer

#Counsel to the Mayor
#The Counsel advises the Mayor on legal matters involving City Hall and the executive staff, and provides counsel to the Mayor on the legal aspects of policy and administrative matters. The Counsel is also charged with overseeing special projects for the Mayor, including the expansion of broadband access across all five boroughs, helping to ensure delivery on the Mayor's equality platform, and has been named the Director for the City's Minority and Women Owned Business Enterprises (MWBE) program. The Counsel oversees the Commission on Women's Issues and the Commission on Human Rights, and serves as a liaison with the Conflicts of Interest Board and the Mayor's Judiciary Committee.
#Counsel to the Mayor - Maya Wiley Salary: $209,000
#Deputy Counsel to the Mayor - Ian Bassin
#Deputy Counsel to the Mayor - Brittny Saunders

#Chief of Staff
#The Chief of Staff oversees the day-to-day operations of the Mayor's schedule and executive office. The Chief of Staff oversees and coordinates the operations of the Office of Appointments, Office of Special Projects and Community Events, Office of Citywide Events Coordination and Management, NYC Service, the Office for International Affairs, the Office of Scheduling & Advance, and Gracie Mansion. The Chief of Staff coordinates all aspects of the Mayor's Office including Correspondence, Facilities, and Administrative Services.
#Chief of Staff - Thomas G. Snyder Salary: $209,000

#Senior Advisor to the Mayor
#The Senior Advisor provides strategic guidance to the Mayor on a wide range of priorities and develops long-term planning for the Administration. The Senior Advisor ensures communications planning and coordination with executive agencies and oversees the Press Office, the Mayor's Office of Speechwriting, the Mayor's Office of Research and Analysis, and the Mayor's Office of Visual Communications, formerly known as the Mayor's Office of Photography. The Senior Advisor also oversees the city's Office of Digital Engagement which includes digital engagement, content creation and social media strategies.
#Senior Advisor to the Mayor - Phil Walzak Salary: $222,182


#Office of Intergovernmental Affairs
#The Office of Intergovernmental Affairs coordinates the activities of the City, State and Federal Legislative Affairs Offices. The Director is charged with working with officials from the City Council to U.S. Congress to implement the Mayor's policies that require legislative and executive support. The Director also oversees the Mayor's Community Affairs Unit, charged with carrying forward mayoral initiatives through direct contact with communities.

#Mayor's Office of Operations
#The Mayor's Office of Operations undertakes projects that make government more customer-focused, innovative, and efficient. The Office of Operations works to make a government of over 40 agencies and 200,000 employees more cost effective and coordinated in carrying out its day-to-day business, and more accessible to the 8 million residents the City serves. The Office of Operations' Performance Management Group also monitors the performance of all City agencies, holding each agency accountable for providing high quality services and making data about the city's performance readily available to the public. The Audit Services Unit oversees agency activity with respect to audits conducted by governmental and non-governmental entities, including the City Comptroller and the State and Federal governments. In addition, the Office of Operations oversees 311, the City's one-stop hotline and online shop for information about City government, the Office of Data Analytics (MODA) the City's civic intelligence center, allowing the City to aggregate and analyze data from across City agencies, and the Center for Economic Opportunity which fights the cycle of poverty in New York City through innovative programs that build human capital and improve financial security.

#Mayor's Office of Contract Services (MOCS)
#Established in 1988 and continued by Executive Order No. 121 of 2008, the Mayor's Office of Contract Services oversees and supports the procurement activities of City agencies; maintains a comprehensive contract information system known as VENDEX; provides online access to public contract information through its Public Access Center; directs the City's procurement reform, streamlining, and new technology efforts; fosters contacts with the vendor community; and administers public hearings for contracts, real property, franchises and concessions and in rem property foreclosure releases; and oversees the Central Insurance Program for nonprofit contractors. The Director is the City Chief Procurement Officer.

#Senior Advisor to the Mayor for Recovery, Resiliency, & Infrastructure
#The Senior Advisor to the Mayor for Recovery, Resiliency, and Infrastructure serves as City Hall's lead on the planning and execution of New York City's broader infrastructure efforts, including Superstorm Sandy recovery and OneNYC. The Senior Advisor will oversee the Mayor's Office of Recovery and Resiliency, the Mayor's Office of Sustainability and the Housing Recovery Office.

#Mayor's Office for People With Disabilities (MOPD)
#The Commissioner co-chairs the City's Americans with Disabilities Act Task Force, the Pedestrian Ramp Committee and serves as a statutory member to the Transportation Disabled Committee.

#Mayor's Office for International Affairs
#and administrating the City of New York/US Department of State Diplomatic and Consular Parking program.

#Mayor's Office of Media & Entertainment (MOME)
#The New York City Mayor's Office of Media and Entertainment (MOME) consists of the Office of Film, Theatre and Broadcasting and NYC Media, the official network of the City of New York; MOME aims to develop the City's diverse media functions, encourage local economic activity in the entertainment industry as well as spur the development of new media. The mission of MOME is to enhance government communications by making information more accessible to the public and leveraging technology to aid in transparency.
#Office of Film Theatre & Broadcasting
#NYC Media


#The Senior Advisor to the Mayor for Recovery, Resiliency, and Infrastructure serves as City Hall's lead on the planning and execution of New York City's broader infrastructure efforts, including Superstorm Sandy recovery and OneNYC. The Senior Advisor will oversee the Mayor's Office of Recovery and Resiliency, the Mayor's Office of Sustainability and the Housing Recovery Office.

#Mayor's Office of Criminal Justice (MOCJ)
#The Mayor's Office of Criminal Justice houses the Office of the Criminal Justice Coordinator (CJC), established pursuant to Section 13 of the City Charter and facilitates cooperation and partnerships among the agencies and actors involved in crime-fighting and criminal justice in New York City. The Mayor's Office of Criminal Justice advises the Mayor on public safety strategy and, together with partners inside and outside government, develops and implements policies aimed at achieving three main goals: reducing crime, reducing unnecessary arrests and incarceration and promoting fairness. Additionally, The Mayor's Office of Criminal Justice serves as a liaison between the NYPD, the Departments of Correction and Probation, the five District Attorney's Offices, and other agencies to help coordinate consistent citywide policy on criminal justice issues.

#Duplicates
governor_duplicate = PublicEntity.find_by(name: 'Office of the Governor')
governor_duplicate.delete
governor_duplicate.save