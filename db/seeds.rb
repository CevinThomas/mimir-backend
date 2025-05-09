# Clear existing data to avoid duplicates
puts 'Cleaning database...'
[Result, AnsweredCard, DeckSessionCard, DeckSession, Choice, Card,
 DecksFolder, FeaturedDecksUser, FavoriteDeck, ViewedDeck, DeckShareSession,
 Deck, Folder, User, Account].each(&:destroy_all)

puts 'Creating accounts...'
# Create accounts
maia = Account.create!({
                         name: 'Maia',
                         email: '@maiamarketing.se',
                         allow_whitelist: true
                       })

seven = Account.create!({
                          name: '7 Software solutions',
                          email: '@gmail.com',
                          allow_whitelist: true
                        })

tech_corp = Account.create!({
                              name: 'TechCorp',
                              email: '@techcorp.com',
                              allow_whitelist: false
                            })

puts 'Creating departments...'
# Create departments
marketing = Department.create!(name: 'Marketing')
engineering = Department.create!(name: 'Engineering')
sales = Department.create!(name: 'Sales')
hr = Department.create!(name: 'Human Resources')

puts 'Creating users...'
# Create users for Maia
jimmy = User.create!({
                       name: 'Jimmy Bjornhard',
                       email: 'jimmy.bjornhard@maiamarketing.se',
                       password: 'password',
                       account_id: maia.id,
                       department_id: marketing.id,
                       role: 'admin',
                       confirmed_at: Time.current
                     })

hilda = User.create!({
                       name: 'Hilda',
                       email: 'hilda@maiamarketing.se',
                       password: 'password',
                       account_id: maia.id,
                       department_id: marketing.id,
                       confirmed_at: Time.current
                     })

# Create users for 7 Software solutions
ceo = User.create!({
                     name: 'CEO of 7 Software solutions',
                     email: 'ceo@gmail.com',
                     password: 'password',
                     account_id: seven.id,
                     department_id: engineering.id,
                     role: 'admin',
                     confirmed_at: Time.current
                   })

dev = User.create!({
                     name: 'Developer',
                     email: 'dev@gmail.com',
                     password: 'password',
                     account_id: seven.id,
                     department_id: engineering.id,
                     confirmed_at: Time.current
                   })

# Create users for TechCorp
admin = User.create!({
                       name: 'Tech Admin',
                       email: 'admin@techcorp.com',
                       password: 'password',
                       account_id: tech_corp.id,
                       department_id: hr.id,
                       role: 'admin',
                       confirmed_at: Time.current
                     })

employee = User.create!({
                          name: 'Tech Employee',
                          email: 'employee@techcorp.com',
                          password: 'password',
                          account_id: tech_corp.id,
                          department_id: sales.id,
                          confirmed_at: Time.current
                        })

puts 'Creating folders...'
# Create folders for each account
folder_names = ['Marketing', 'Sales', 'Engineering', 'HR', 'Finance', 'Operations', 'Product', 'Customer Support',
                'Legal', 'Research']
folder_users = {
  maia => [jimmy, hilda],
  seven => [ceo, dev],
  tech_corp => [admin, employee]
}

account_folders = {}

# Create random folders for each account
[maia, seven, tech_corp].each do |account|
  # Always create an uncategorized folder
  account_folders[account.name] = [account.folders.create!(name: 'Uncategorized')]

  # Create random number of additional folders (0-7)
  num_folders = rand(0..7)

  num_folders.times do
    folder_name = folder_names.sample
    user = folder_users[account].sample
    folder = account.folders.create!(name: folder_name, user: user)
    account_folders[account.name] << folder
  end

  puts "Created #{num_folders + 1} folders for #{account.name}"
end

puts 'Creating decks...'

# Deck name and description templates
deck_templates = [
  { name: 'Marketing Basics', description: 'Basic marketing concepts and strategies' },
  { name: 'Social Media Strategy', description: 'Effective social media marketing techniques' },
  { name: 'Coding Basics', description: 'Fundamental programming concepts' },
  { name: 'Agile Methodology', description: 'Understanding agile development practices' },
  { name: 'HR Policies', description: 'Company HR policies and procedures' },
  { name: 'Sales Training', description: 'Training materials for the sales team' },
  { name: 'Customer Service', description: 'Best practices for customer service' },
  { name: 'Product Management', description: 'Strategies for effective product management' },
  { name: 'Financial Planning', description: 'Basics of financial planning and analysis' },
  { name: 'Leadership Skills', description: 'Developing effective leadership skills' },
  { name: 'Project Management', description: 'Methodologies for successful project management' },
  { name: 'Data Analysis', description: 'Techniques for analyzing and interpreting data' },
  { name: 'UX Design', description: 'Principles of user experience design' },
  { name: 'Content Creation', description: 'Creating engaging content for various platforms' },
  { name: 'SEO Fundamentals', description: 'Search engine optimization basics' }
]

# Store all created decks
all_decks = {}
featured_decks = {}

# Create decks for each account
[maia, seven, tech_corp].each do |account|
  account_name = account.name
  all_decks[account_name] = []
  featured_decks[account_name] = []

  # Get users for this account
  account_users = folder_users[account]

  # Create 3-8 private decks for each account
  num_private_decks = rand(3..8)
  puts "Creating #{num_private_decks} private decks for #{account_name}"

  num_private_decks.times do
    template = deck_templates.sample
    user = account_users.sample

    deck = Deck.create!({
                          name: template[:name],
                          description: template[:description],
                          user: user,
                          account: account,
                          active: true,
                          deck_type: 'private'
                        })

    all_decks[account_name] << deck
  end

  # Create 1-4 shared decks for each account
  num_shared_decks = rand(1..4)
  puts "Creating #{num_shared_decks} shared decks for #{account_name}"

  num_shared_decks.times do
    template = deck_templates.sample
    user = account_users.sample

    deck = Deck.create!({
                          name: template[:name],
                          description: template[:description],
                          user: user,
                          account: account,
                          active: true,
                          deck_type: 'account'
                        })

    all_decks[account_name] << deck

    # Create deck share sessions for this deck with users from other accounts
    other_accounts = [maia, seven, tech_corp].reject { |a| a == account }
    share_with_user = folder_users[other_accounts.sample].sample

    DeckShareSession.create!({
                               deck: deck,
                               user: share_with_user,
                               owner_user: user,
                               active: true
                             })
  end

  # Create 1-5 decks for each folder
  account_folders[account_name].each do |folder|
    num_folder_decks = rand(1..5)
    puts "Creating #{num_folder_decks} decks for folder #{folder.name} in #{account_name}"

    num_folder_decks.times do
      template = deck_templates.sample
      user = account_users.sample

      deck = Deck.create!({
                            name: template[:name],
                            description: template[:description],
                            user: user,
                            account: account,
                            active: true,
                            deck_type: 'account'
                          })

      all_decks[account_name] << deck

      # Associate deck with folder
      DecksFolder.create!(deck: deck, folder: folder, account_id: account.id)
    end
  end

  # Create 1-4 featured decks for each account
  num_featured_decks = rand(1..4)
  featured_deck_candidates = all_decks[account_name].select { |d| d.deck_type == 'account' }

  featured_deck_candidates.sample(num_featured_decks).each do |deck|
    deck.update!(featured: true)
    featured_decks[account_name] << deck

    # Create featured decks users
    account_users.each do |user|
      FeaturedDecksUser.create!({
                                  user: user,
                                  deck: deck
                                })
    end
  end

  puts "Created #{num_featured_decks} featured decks for #{account_name}"
end

# Reference specific decks for later use in the seed file
marketing_basics = all_decks['Maia'].find { |d| d.name.include?('Marketing') }
coding_basics = all_decks['7 Software solutions'].find { |d| d.name.include?('Coding') }
hr_policies = all_decks['TechCorp'].find { |d| d.name.include?('HR') }

# If any of these are nil, use the first deck from each account
marketing_basics ||= all_decks['Maia'].first
coding_basics ||= all_decks['7 Software solutions'].first
hr_policies ||= all_decks['TechCorp'].first

# NOTE: Deck-folder associations are already created in the deck creation loop above

puts 'Creating cards and choices...'

# Helper method to create cards with choices for a deck
def create_cards_for_deck(deck, num_cards, card_data)
  cards = []

  num_cards.times do |i|
    # Use predefined data if available, otherwise use generated data
    data = card_data[i] || {
      title: "#{deck.name} Question #{i + 1}",
      description: "This is a question about #{deck.name.downcase}",
      explanation: "Explanation for question #{i + 1}"
    }

    card = Card.create!({
                          title: data[:title],
                          description: data[:description],
                          explanation: data[:explanation],
                          deck: deck
                        })

    # Create one correct choice and two incorrect choices
    Choice.create!({
                     title: data[:correct_choice] || "Correct answer for #{data[:title]}",
                     description: data[:correct_description],
                     correct: true,
                     card: card
                   })

    Choice.create!({
                     title: data[:incorrect_choice1] || "Incorrect answer 1 for #{data[:title]}",
                     description: data[:incorrect1_description],
                     correct: false,
                     card: card
                   })

    Choice.create!({
                     title: data[:incorrect_choice2] || "Incorrect answer 2 for #{data[:title]}",
                     description: data[:incorrect2_description],
                     correct: false,
                     card: card
                   })

    cards << card
  end

  cards
end

# Define card data for Marketing Basics deck
marketing_cards_data = [
  {
    title: 'What is Marketing?',
    description: 'Define marketing as a business concept',
    correct_choice: 'The process of promoting and selling products or services',
    correct_description: 'Including market research and advertising',
    incorrect_choice1: 'The process of manufacturing products',
    incorrect1_description: 'Including production and distribution',
    incorrect_choice2: 'The process of hiring employees',
    incorrect2_description: 'Including recruitment and training'
  },
  {
    title: 'What is a Target Market?',
    description: 'Define target market in marketing',
    explanation: 'A target market is a specific group of consumers at which a company aims its products and services.',
    correct_choice: 'A specific group of consumers at which a company aims its products and services',
    incorrect_choice1: 'The geographical area where a company sells its products',
    incorrect_choice2: 'The total market for a product category'
  },
  {
    title: 'What is Market Segmentation?',
    description: 'Define market segmentation in marketing',
    explanation: 'Market segmentation is the process of dividing a market into distinct groups of buyers who have different needs, characteristics, or behaviors.',
    correct_choice: 'The process of dividing a market into distinct groups of buyers',
    incorrect_choice1: 'The process of combining multiple markets into one',
    incorrect_choice2: 'The process of eliminating unprofitable market segments'
  },
  {
    title: 'What is a Marketing Mix?',
    description: 'Define the marketing mix concept',
    explanation: 'The marketing mix refers to the set of actions, or tactics, that a company uses to promote its brand or product in the market.',
    correct_choice: 'The set of tactical marketing tools: product, price, place, and promotion',
    incorrect_choice1: 'The combination of different marketing campaigns',
    incorrect_choice2: 'The mix of different target markets'
  },
  {
    title: 'What is Brand Equity?',
    description: 'Define brand equity in marketing',
    explanation: 'Brand equity refers to the value of a brand. It is based on the idea that a well-established brand has value beyond the physical assets of the company.',
    correct_choice: 'The value a brand adds to a product beyond its functional benefits',
    incorrect_choice1: 'The financial value of a company\'s physical assets',
    incorrect_choice2: 'The cost of creating a brand logo and identity'
  },
  {
    title: 'What is Content Marketing?',
    description: 'Define content marketing',
    explanation: 'Content marketing is a strategic marketing approach focused on creating and distributing valuable, relevant, and consistent content to attract and retain a clearly defined audience.',
    correct_choice: 'Creating and sharing valuable content to attract and convert prospects',
    incorrect_choice1: 'Paid advertising on social media platforms',
    incorrect_choice2: 'Direct mail campaigns to potential customers'
  },
  {
    title: 'What is a SWOT Analysis?',
    description: 'Define SWOT analysis in marketing',
    explanation: 'SWOT analysis is a strategic planning technique used to help identify strengths, weaknesses, opportunities, and threats related to business competition or project planning.',
    correct_choice: 'A framework for analyzing strengths, weaknesses, opportunities, and threats',
    incorrect_choice1: 'A method for calculating return on marketing investment',
    incorrect_choice2: 'A technique for designing marketing campaigns'
  },
  {
    title: 'What is Customer Lifetime Value (CLV)?',
    description: 'Define CLV in marketing',
    explanation: 'Customer Lifetime Value is the total worth to a business of a customer over the whole period of their relationship.',
    correct_choice: 'The predicted net profit from the entire future relationship with a customer',
    incorrect_choice1: 'The amount a customer spends on their first purchase',
    incorrect_choice2: 'The cost of acquiring a new customer'
  },
  {
    title: 'What is Search Engine Optimization (SEO)?',
    description: 'Define SEO in digital marketing',
    explanation: 'SEO is the practice of increasing the quantity and quality of traffic to your website through organic search engine results.',
    correct_choice: 'The process of improving a website to increase its visibility in search engines',
    incorrect_choice1: 'Paying for advertisements on search engines',
    incorrect_choice2: 'Creating a search function within a website'
  },
  {
    title: 'What is a Call to Action (CTA)?',
    description: 'Define CTA in marketing',
    explanation: 'A call to action is a marketing term for any design to prompt an immediate response or encourage an immediate sale.',
    correct_choice: 'An instruction to the audience to provoke an immediate response',
    incorrect_choice1: 'A phone call made to a potential customer',
    incorrect_choice2: 'A legal action taken against a competitor'
  }
]

# Define card data for Coding Basics deck
coding_cards_data = [
  {
    title: 'What is a Variable?',
    description: 'Define what a variable is in programming',
    correct_choice: 'A storage location paired with an associated symbolic name that contains a value',
    incorrect_choice1: 'A fixed value that cannot be changed',
    incorrect_choice2: 'A type of function in programming'
  },
  {
    title: 'What is a Function?',
    description: 'Define what a function is in programming',
    explanation: 'A function is a block of organized, reusable code that is used to perform a single, related action.',
    correct_choice: 'A block of organized, reusable code that performs a specific task',
    incorrect_choice1: 'A mathematical equation used in programming',
    incorrect_choice2: 'A type of variable in programming'
  },
  {
    title: 'What is an Array?',
    description: 'Define what an array is in programming',
    explanation: 'An array is a data structure consisting of a collection of elements, each identified by at least one array index or key.',
    correct_choice: 'A data structure that stores a collection of elements',
    incorrect_choice1: 'A function that performs multiple operations',
    incorrect_choice2: 'A type of loop in programming'
  },
  {
    title: 'What is Object-Oriented Programming?',
    description: 'Define OOP in programming',
    explanation: 'Object-oriented programming is a programming paradigm based on the concept of "objects", which can contain data and code.',
    correct_choice: 'A programming paradigm based on the concept of objects',
    incorrect_choice1: 'A programming language developed by Microsoft',
    incorrect_choice2: 'A method for organizing code in alphabetical order'
  },
  {
    title: 'What is a Loop?',
    description: 'Define what a loop is in programming',
    explanation: 'A loop is a sequence of instructions that is continually repeated until a certain condition is reached.',
    correct_choice: 'A control structure that repeats a sequence of instructions',
    incorrect_choice1: 'A type of error in programming',
    incorrect_choice2: 'A method for connecting to a database'
  },
  {
    title: 'What is a Conditional Statement?',
    description: 'Define conditional statements in programming',
    explanation: 'Conditional statements are used to perform different actions based on different conditions.',
    correct_choice: 'A statement that performs different actions based on whether a condition is true or false',
    incorrect_choice1: 'A statement that always executes regardless of conditions',
    incorrect_choice2: 'A statement that defines the terms of a software license'
  },
  {
    title: 'What is a Database?',
    description: 'Define what a database is in programming',
    explanation: 'A database is an organized collection of data stored and accessed electronically.',
    correct_choice: 'An organized collection of data stored and accessed electronically',
    incorrect_choice1: 'A programming language for web development',
    incorrect_choice2: 'A tool for debugging code'
  },
  {
    title: 'What is an API?',
    description: 'Define what an API is in programming',
    explanation: 'An API (Application Programming Interface) is a set of rules that allows programs to talk to each other.',
    correct_choice: 'A set of rules that allows programs to communicate with each other',
    incorrect_choice1: 'A type of programming language',
    incorrect_choice2: 'A hardware component in computers'
  },
  {
    title: 'What is Version Control?',
    description: 'Define version control in programming',
    explanation: 'Version control is a system that records changes to a file or set of files over time so that you can recall specific versions later.',
    correct_choice: 'A system that tracks changes to files over time',
    incorrect_choice1: 'A method for controlling access to a database',
    incorrect_choice2: 'A technique for optimizing code performance'
  },
  {
    title: 'What is Debugging?',
    description: 'Define debugging in programming',
    explanation: 'Debugging is the process of finding and resolving defects or problems within a computer program.',
    correct_choice: 'The process of identifying and fixing errors in code',
    incorrect_choice1: 'The process of adding new features to a program',
    incorrect_choice2: 'The process of converting code from one language to another'
  }
]

# Define card data for HR Policies deck
hr_cards_data = [
  {
    title: 'What is PTO?',
    description: 'Define PTO in HR context',
    correct_choice: 'Paid Time Off - compensated time away from work provided by an employer',
    incorrect_choice1: 'Personal Time Organization - a method for managing work schedules',
    incorrect_choice2: 'Professional Training Opportunity - company-sponsored training programs'
  },
  {
    title: 'What is Onboarding?',
    description: 'Define onboarding in HR',
    explanation: 'Onboarding is the process of integrating a new employee into an organization and its culture.',
    correct_choice: 'The process of integrating new employees into an organization',
    incorrect_choice1: 'The process of terminating employment',
    incorrect_choice2: 'The process of conducting performance reviews'
  },
  {
    title: 'What is a Performance Review?',
    description: 'Define performance review in HR',
    explanation: 'A performance review is a formal assessment of an employee\'s work performance.',
    correct_choice: 'A formal assessment of an employee\'s work performance',
    incorrect_choice1: 'A review of company policies by management',
    incorrect_choice2: 'A financial audit of company expenses'
  },
  {
    title: 'What is FMLA?',
    description: 'Define FMLA in HR context',
    explanation: 'The Family and Medical Leave Act (FMLA) is a U.S. labor law that provides eligible employees with job-protected, unpaid leave for qualified medical and family reasons.',
    correct_choice: 'Family and Medical Leave Act - provides job-protected leave for medical and family reasons',
    incorrect_choice1: 'Federal Management of Labor Activities - regulates union activities',
    incorrect_choice2: 'Financial Management and Legal Assistance - provides financial planning for employees'
  },
  {
    title: 'What is Workers\' Compensation?',
    description: 'Define workers\' compensation in HR',
    explanation: 'Workers\' compensation is a form of insurance that provides wage replacement and medical benefits to employees who are injured in the course of employment.',
    correct_choice: 'Insurance that provides benefits to employees injured on the job',
    incorrect_choice1: 'A bonus system for high-performing employees',
    incorrect_choice2: 'A retirement plan for long-term employees'
  },
  {
    title: 'What is an Employee Handbook?',
    description: 'Define employee handbook in HR',
    explanation: 'An employee handbook is a document that communicates an organization\'s mission, policies, and expectations.',
    correct_choice: 'A document that outlines company policies, procedures, and expectations',
    incorrect_choice1: 'A personal development plan for employees',
    incorrect_choice2: 'A financial ledger tracking employee expenses'
  },
  {
    title: 'What is Diversity and Inclusion?',
    description: 'Define diversity and inclusion in HR',
    explanation: 'Diversity and inclusion in the workplace refers to a company\'s mission to create a welcoming environment for all, regardless of race, gender, religion, age, disability, or sexual orientation.',
    correct_choice: 'Practices that create a welcoming environment for people of all backgrounds',
    incorrect_choice1: 'A training program for international employees',
    incorrect_choice2: 'A policy requiring hiring from diverse educational backgrounds'
  },
  {
    title: 'What is Sexual Harassment?',
    description: 'Define sexual harassment in the workplace',
    explanation: 'Sexual harassment is unwelcome sexual advances, requests for sexual favors, and other verbal or physical conduct of a sexual nature that affects an individual\'s employment.',
    correct_choice: 'Unwelcome sexual advances or conduct that affects employment',
    incorrect_choice1: 'Consensual relationships between employees',
    incorrect_choice2: 'Discussions about gender equality in the workplace'
  },
  {
    title: 'What is a Non-Disclosure Agreement (NDA)?',
    description: 'Define NDA in HR context',
    explanation: 'A non-disclosure agreement is a legal contract between parties that outlines confidential material or knowledge the parties wish to share with one another but wish to restrict from other access.',
    correct_choice: 'A legal agreement that restricts sharing of confidential information',
    incorrect_choice1: 'A contract that prevents employees from working for competitors',
    incorrect_choice2: 'An agreement about salary non-disclosure among employees'
  },
  {
    title: 'What is Employee Engagement?',
    description: 'Define employee engagement in HR',
    explanation: 'Employee engagement is the level of enthusiasm and dedication an employee feels toward their job.',
    correct_choice: 'The level of enthusiasm and dedication an employee feels toward their job',
    incorrect_choice1: 'The process of hiring new employees',
    incorrect_choice2: 'A system for tracking employee attendance'
  }
]

# Define card data for Social Media Strategy deck
social_media_cards_data = [
  {
    title: 'What is Social Media Marketing?',
    description: 'Define social media marketing',
    explanation: 'Social media marketing is the use of social media platforms to connect with your audience to build your brand, increase sales, and drive website traffic.',
    correct_choice: 'Using social media platforms to promote products and connect with customers',
    incorrect_choice1: 'Traditional advertising through television and radio',
    incorrect_choice2: 'Direct mail campaigns to potential customers'
  },
  {
    title: 'What is a Social Media Algorithm?',
    description: 'Define social media algorithm',
    explanation: 'A social media algorithm is a set of rules that determines what content users see on their feeds.',
    correct_choice: 'A set of rules that determines what content users see on their feeds',
    incorrect_choice1: 'A mathematical formula for calculating engagement rates',
    incorrect_choice2: 'A tool for scheduling social media posts'
  },
  {
    title: 'What is Engagement Rate?',
    description: 'Define engagement rate in social media',
    explanation: 'Engagement rate is a metric that measures how actively involved with your content your audience is.',
    correct_choice: 'A metric measuring how users interact with content through likes, comments, shares, etc.',
    incorrect_choice1: 'The rate at which new followers are gained',
    incorrect_choice2: 'The percentage of users who click on paid advertisements'
  },
  {
    title: 'What is a Hashtag?',
    description: 'Define hashtag in social media',
    explanation: 'A hashtag is a word or phrase preceded by the # symbol, used to identify messages on a specific topic.',
    correct_choice: 'A word or phrase preceded by # used to categorize content and make it discoverable',
    incorrect_choice1: 'A paid promotion on social media platforms',
    incorrect_choice2: 'A type of social media account for businesses'
  },
  {
    title: 'What is Influencer Marketing?',
    description: 'Define influencer marketing',
    explanation: 'Influencer marketing is a form of social media marketing involving endorsements and product placements from influencers.',
    correct_choice: 'Marketing that uses endorsements from people with dedicated social followings',
    incorrect_choice1: 'Marketing that influences consumer behavior through psychology',
    incorrect_choice2: 'Marketing that focuses on influential business leaders'
  },
  {
    title: 'What is a Social Media Content Calendar?',
    description: 'Define content calendar in social media',
    explanation: 'A social media content calendar is a schedule of when and what you will post on social media platforms.',
    correct_choice: 'A schedule that organizes what and when to post on social media',
    incorrect_choice1: 'A tool that automatically generates social media content',
    incorrect_choice2: 'A calendar showing when social media platforms were founded'
  },
  {
    title: 'What is a Social Media Audit?',
    description: 'Define social media audit',
    explanation: 'A social media audit is an evaluation of your social media accounts and their performance.',
    correct_choice: 'An evaluation of social media accounts and their performance',
    incorrect_choice1: 'A financial audit of spending on social media advertising',
    incorrect_choice2: 'A security check of social media passwords and access'
  },
  {
    title: 'What is a Social Media Policy?',
    description: 'Define social media policy',
    explanation: 'A social media policy is a corporate code of conduct that provides guidelines for employees who post content on social media.',
    correct_choice: 'Guidelines for how employees should conduct themselves on social media',
    incorrect_choice1: 'Rules set by social media platforms for all users',
    incorrect_choice2: 'Laws governing the use of social media in marketing'
  },
  {
    title: 'What is Social Listening?',
    description: 'Define social listening',
    explanation: 'Social listening is the monitoring of social media channels for mentions of your brand, competitors, product, and more.',
    correct_choice: 'Monitoring social media for mentions of your brand, competitors, and industry',
    incorrect_choice1: 'Listening to customer service calls for feedback',
    incorrect_choice2: 'Conducting focus groups about social issues'
  },
  {
    title: 'What is User-Generated Content (UGC)?',
    description: 'Define UGC in social media',
    explanation: 'User-generated content is any content created by unpaid contributors or fans rather than the brand itself.',
    correct_choice: 'Content created by users or customers rather than the brand',
    incorrect_choice1: 'Content created by the marketing team for users',
    incorrect_choice2: 'Content generated by artificial intelligence'
  }
]

# Define card data for Agile Methodology deck
agile_cards_data = [
  {
    title: 'What is Agile?',
    description: 'Define Agile methodology',
    explanation: 'Agile is an iterative approach to project management and software development that helps teams deliver value to their customers faster.',
    correct_choice: 'An iterative approach to project management and software development',
    incorrect_choice1: 'A programming language for web development',
    incorrect_choice2: 'A type of software testing methodology'
  },
  {
    title: 'What is a Sprint?',
    description: 'Define Sprint in Agile',
    explanation: 'A Sprint is a time-boxed period during which specific work has to be completed and made ready for review.',
    correct_choice: 'A time-boxed period for completing specific work in Scrum',
    incorrect_choice1: 'A fast-paced coding competition',
    incorrect_choice2: 'A method for quickly fixing bugs in code'
  },
  {
    title: 'What is a User Story?',
    description: 'Define User Story in Agile',
    explanation: 'A user story is an informal, natural language description of features of a software system from the end-user perspective.',
    correct_choice: 'A description of software features written from the end-user\'s perspective',
    incorrect_choice1: 'A case study of user experiences with a product',
    incorrect_choice2: 'A fictional character created to represent a user type'
  },
  {
    title: 'What is the Scrum Framework?',
    description: 'Define Scrum in Agile',
    explanation: 'Scrum is a framework within which people can address complex adaptive problems, while productively and creatively delivering products of the highest possible value.',
    correct_choice: 'A framework for managing complex projects with an emphasis on software delivery',
    incorrect_choice1: 'A technique for organizing code repositories',
    incorrect_choice2: 'A method for testing software security'
  },
  {
    title: 'What is a Product Backlog?',
    description: 'Define Product Backlog in Agile',
    explanation: 'A product backlog is a prioritized list of work for the development team that is derived from the roadmap and its requirements.',
    correct_choice: 'A prioritized list of features and requirements for a product',
    incorrect_choice1: 'A list of bugs and issues found in a product',
    incorrect_choice2: 'A history of all previous product versions'
  },
  {
    title: 'What is a Daily Stand-up?',
    description: 'Define Daily Stand-up in Agile',
    explanation: 'A daily stand-up is a daily meeting held by the Scrum team to share progress, identify impediments, and plan the day\'s work.',
    correct_choice: 'A short daily meeting where team members share progress and plans',
    incorrect_choice1: 'A physical exercise routine for development teams',
    incorrect_choice2: 'A standing desk arrangement for programmers'
  },
  {
    title: 'What is Continuous Integration?',
    description: 'Define Continuous Integration in Agile',
    explanation: 'Continuous Integration is the practice of merging all developers\' working copies to a shared mainline several times a day.',
    correct_choice: 'The practice of frequently merging code changes into a shared repository',
    incorrect_choice1: 'The continuous addition of new features to a product',
    incorrect_choice2: 'The integration of multiple software systems'
  },
  {
    title: 'What is a Retrospective?',
    description: 'Define Retrospective in Agile',
    explanation: 'A retrospective is a meeting held at the end of a Sprint to review what went well, what could be improved, and how to incorporate learnings into future Sprints.',
    correct_choice: 'A meeting to reflect on the past Sprint and identify improvements',
    incorrect_choice1: 'A historical analysis of a project\'s development',
    incorrect_choice2: 'A review of outdated code that needs refactoring'
  },
  {
    title: 'What is Kanban?',
    description: 'Define Kanban in Agile',
    explanation: 'Kanban is a visual system for managing work as it moves through a process, emphasizing continuous delivery without overburdening the development team.',
    correct_choice: 'A visual method for managing work with an emphasis on continuous delivery',
    incorrect_choice1: 'A Japanese programming language',
    incorrect_choice2: 'A type of database management system'
  },
  {
    title: 'What is Velocity?',
    description: 'Define Velocity in Agile',
    explanation: 'Velocity is a measure of the amount of work a team can tackle during a single Sprint.',
    correct_choice: 'A measure of how much work a team can complete in a Sprint',
    incorrect_choice1: 'The speed at which code executes',
    incorrect_choice2: 'A metric for how quickly users navigate through a website'
  }
]

# Define card data for Sales Training deck
sales_cards_data = [
  {
    title: 'What is a Sales Funnel?',
    description: 'Define sales funnel in sales',
    explanation: 'A sales funnel is a visual representation of the journey a prospect takes from first awareness to final purchase.',
    correct_choice: 'A model that describes the customer journey from awareness to purchase',
    incorrect_choice1: 'A tool for collecting leads at trade shows',
    incorrect_choice2: 'A method for organizing sales territories'
  },
  {
    title: 'What is a Qualified Lead?',
    description: 'Define qualified lead in sales',
    explanation: 'A qualified lead is a potential customer who has been evaluated and determined to have a high likelihood of becoming a customer.',
    correct_choice: 'A prospect who meets criteria indicating they are likely to become a customer',
    incorrect_choice1: 'A salesperson who has completed training',
    incorrect_choice2: 'A customer who has made multiple purchases'
  },
  {
    title: 'What is Cold Calling?',
    description: 'Define cold calling in sales',
    explanation: 'Cold calling is the solicitation of business from potential customers who have had no prior contact with the salesperson.',
    correct_choice: 'Contacting potential customers who have had no prior interaction with you',
    incorrect_choice1: 'Calling existing customers during winter months',
    incorrect_choice2: 'Making sales calls from a cold, quiet environment'
  },
  {
    title: 'What is a Value Proposition?',
    description: 'Define value proposition in sales',
    explanation: 'A value proposition is a statement that explains how a product solves customers\' problems, delivers specific benefits, and tells the ideal customer why they should buy from you and not from the competition.',
    correct_choice: 'A statement explaining why customers should buy your product or service',
    incorrect_choice1: 'A pricing strategy for premium products',
    incorrect_choice2: 'A method for valuing a business for sale'
  },
  {
    title: 'What is Upselling?',
    description: 'Define upselling in sales',
    explanation: 'Upselling is a sales technique where a seller invites the customer to purchase more expensive items, upgrades, or other add-ons to generate more revenue.',
    correct_choice: 'Encouraging customers to purchase a higher-end product or add-ons',
    incorrect_choice1: 'Selling products at a higher price than competitors',
    incorrect_choice2: 'Moving unsold inventory through discounts'
  },
  {
    title: 'What is a Sales Quota?',
    description: 'Define sales quota in sales',
    explanation: 'A sales quota is a sales target, or goal, that is set for a specific time period, sales team, or individual salesperson.',
    correct_choice: 'A target amount of sales that must be achieved in a specific time period',
    incorrect_choice1: 'A limit on how many products can be sold to a single customer',
    incorrect_choice2: 'A restriction on which products can be sold in certain regions'
  },
  {
    title: 'What is a Sales Pipeline?',
    description: 'Define sales pipeline in sales',
    explanation: 'A sales pipeline is a visual representation of sales prospects and where they are in the purchasing process.',
    correct_choice: 'A visual representation of where prospects are in the sales process',
    incorrect_choice1: 'A physical location where sales transactions occur',
    incorrect_choice2: 'A method for transferring leads between sales teams'
  },
  {
    title: 'What is Objection Handling?',
    description: 'Define objection handling in sales',
    explanation: 'Objection handling is the process of addressing and overcoming a prospect\'s concerns or hesitations about a product or service.',
    correct_choice: 'Addressing and overcoming customer concerns during the sales process',
    incorrect_choice1: 'Refusing to sell to difficult customers',
    incorrect_choice2: 'Filing formal objections against competitor sales tactics'
  },
  {
    title: 'What is a Closing Technique?',
    description: 'Define closing technique in sales',
    explanation: 'A closing technique is a method used by salespeople to convert a prospect into a customer by getting them to commit to a purchase.',
    correct_choice: 'A method used to get prospects to commit to a purchase',
    incorrect_choice1: 'A way to end a sales meeting politely',
    incorrect_choice2: 'A technique for closing a business at the end of the day'
  },
  {
    title: 'What is a Referral in Sales?',
    description: 'Define referral in sales context',
    explanation: 'A referral in sales is when an existing customer recommends your product or service to a new prospect.',
    correct_choice: 'When an existing customer recommends your product to a new prospect',
    incorrect_choice1: 'When a salesperson is transferred to a different department',
    incorrect_choice2: 'When a sale is referred to management for approval'
  }
]

# Define card data for Private Marketing Notes deck
private_deck_cards_data = [
  {
    title: 'What is Guerrilla Marketing?',
    description: 'Define guerrilla marketing',
    explanation: 'Guerrilla marketing is an advertisement strategy in which a company uses surprise and/or unconventional interactions in order to promote a product or service.',
    correct_choice: 'An unconventional marketing strategy that relies on surprise and creativity',
    incorrect_choice1: 'Marketing that involves military-themed campaigns',
    incorrect_choice2: 'Marketing that targets competitors\' customers directly'
  },
  {
    title: 'What is Neuromarketing?',
    description: 'Define neuromarketing',
    explanation: 'Neuromarketing is the application of neuroscience to marketing. It includes the direct use of brain imaging, scanning, or other brain activity measurement technology to measure a subject\'s response to specific products, packaging, advertising, or other marketing elements.',
    correct_choice: 'The application of neuroscience to understand consumer responses to marketing',
    incorrect_choice1: 'Marketing targeted specifically at neuroscientists',
    incorrect_choice2: 'Marketing that uses neural networks and AI'
  },
  {
    title: 'What is Growth Hacking?',
    description: 'Define growth hacking in marketing',
    explanation: 'Growth hacking is a process of rapid experimentation across marketing channels and product development to identify the most effective ways to grow a business.',
    correct_choice: 'A process focused on rapid experimentation to find the most efficient ways to grow a business',
    incorrect_choice1: 'Illegal marketing techniques that bypass regulations',
    incorrect_choice2: 'Using computer hacking to gain marketing advantages'
  },
  {
    title: 'What is Conversion Rate Optimization (CRO)?',
    description: 'Define CRO in marketing',
    explanation: 'Conversion Rate Optimization is the systematic process of increasing the percentage of website visitors who take a desired action.',
    correct_choice: 'The process of increasing the percentage of visitors who take a desired action',
    incorrect_choice1: 'Converting marketing expenses into revenue',
    incorrect_choice2: 'Optimizing the rate at which leads convert to sales'
  },
  {
    title: 'What is A/B Testing?',
    description: 'Define A/B testing in marketing',
    explanation: 'A/B testing is a method of comparing two versions of a webpage or app against each other to determine which one performs better.',
    correct_choice: 'Comparing two versions of something to see which performs better',
    incorrect_choice1: 'Testing products with groups A and B of consumers',
    incorrect_choice2: 'Grading marketing campaigns on a scale from A to B'
  },
  {
    title: 'What is Customer Segmentation?',
    description: 'Define customer segmentation in marketing',
    explanation: 'Customer segmentation is the practice of dividing a customer base into groups of individuals that are similar in specific ways relevant to marketing.',
    correct_choice: 'Dividing customers into groups based on similar characteristics',
    incorrect_choice1: 'Separating customers based on their profitability',
    incorrect_choice2: 'Dividing the market into geographic segments'
  },
  {
    title: 'What is Viral Marketing?',
    description: 'Define viral marketing',
    explanation: 'Viral marketing is a business strategy that uses existing social networks to promote a product, mainly on various social media platforms.',
    correct_choice: 'Marketing that encourages people to share content with their networks',
    incorrect_choice1: 'Marketing that spreads like a virus, causing harm',
    incorrect_choice2: 'Marketing specifically for healthcare products'
  },
  {
    title: 'What is Remarketing?',
    description: 'Define remarketing in digital marketing',
    explanation: 'Remarketing is a form of online advertising that enables sites to show targeted ads to users who have already visited their site.',
    correct_choice: 'Showing ads to users who have previously visited your website',
    incorrect_choice1: 'Reusing old marketing campaigns to save costs',
    incorrect_choice2: 'Marketing products that have been remanufactured'
  },
  {
    title: 'What is Native Advertising?',
    description: 'Define native advertising',
    explanation: 'Native advertising is a type of advertising that matches the form and function of the platform upon which it appears.',
    correct_choice: 'Advertising that matches the look and feel of the media format in which it appears',
    incorrect_choice1: 'Advertising that only targets native residents of a country',
    incorrect_choice2: 'Advertising that uses indigenous cultural elements'
  },
  {
    title: 'What is Marketing Automation?',
    description: 'Define marketing automation',
    explanation: 'Marketing automation is technology that manages marketing processes and multifunctional campaigns across multiple channels automatically.',
    correct_choice: 'Technology that automatically manages marketing processes across channels',
    incorrect_choice1: 'Replacing marketing staff with automated systems',
    incorrect_choice2: 'Using robots for physical marketing activities'
  }
]

# Define card data for Inactive and Expired decks

# Create cards for each deck using the helper method
puts 'Creating cards for decks...'

# Create cards for the reference decks we'll use later
marketing_cards = create_cards_for_deck(marketing_basics, rand(10..20), marketing_cards_data)
coding_cards = create_cards_for_deck(coding_basics, rand(10..20), coding_cards_data)
create_cards_for_deck(hr_policies, rand(10..20), hr_cards_data)

# Create cards for other decks
[maia, seven, tech_corp].each do |account|
  # Get all decks for this account
  account_decks = all_decks[account.name]

  # Create cards for each deck
  account_decks.each do |deck|
    # Skip the decks we've already created cards for
    next if [marketing_basics.id, coding_basics.id, hr_policies.id].include?(deck.id)

    # Choose appropriate card data based on deck name
    card_data = if deck.name.include?('Marketing') || deck.name.include?('Social Media')
                  marketing_cards_data
                elsif deck.name.include?('Coding') || deck.name.include?('Agile')
                  coding_cards_data
                elsif deck.name.include?('HR') || deck.name.include?('Sales')
                  hr_cards_data
                elsif deck.deck_type == 'private'
                  private_deck_cards_data
                else
                  # Use a random card data set
                  [marketing_cards_data, coding_cards_data, hr_cards_data,
                   social_media_cards_data, agile_cards_data, sales_cards_data,
                   private_deck_cards_data].sample
                end

    # Create cards for this deck
    create_cards_for_deck(deck, rand(5..10), card_data)
  end
end

puts 'Creating deck sessions and answered cards...'
# Create deck sessions and answered cards
marketing_session = DeckSession.create!({
                                          deck: marketing_basics,
                                          user: hilda
                                        })

coding_session = DeckSession.create!({
                                       deck: coding_basics,
                                       user: dev
                                     })

# Create answered cards for marketing session
AnsweredCard.create!({
                       card: marketing_cards[0],
                       deck_session: marketing_session,
                       choice: marketing_cards[0].choices.find_by(correct: true),
                       user_id: hilda.id,
                       correct: true,
                       answered_at: 10.minutes.ago
                     })

AnsweredCard.create!({
                       card: marketing_cards[1],
                       deck_session: marketing_session,
                       choice: marketing_cards[1].choices.find_by(correct: false),
                       user_id: hilda.id,
                       correct: false,
                       answered_at: 5.minutes.ago
                     })

# Create answered cards for coding session
AnsweredCard.create!({
                       card: coding_cards[0],
                       deck_session: coding_session,
                       choice: coding_cards[0].choices.find_by(correct: true),
                       user_id: dev.id,
                       correct: true,
                       answered_at: 15.minutes.ago
                     })

# Create results for completed sessions
Result.create!({
                 deck_session: marketing_session,
                 correct_answers: 1,
                 total_cards: 2,
                 timespan: '15 minutes'
               })

puts 'Creating favorite decks and viewed decks...'
# Create favorite decks
FavoriteDeck.create!({
                       user: hilda,
                       deck: coding_basics,
                       account: maia
                     })

FavoriteDeck.create!({
                       user: dev,
                       deck: marketing_basics,
                       account: seven
                     })

# Create viewed decks
ViewedDeck.create!({
                     user: hilda,
                     deck: marketing_basics,
                     account: maia
                   })

ViewedDeck.create!({
                     user: dev,
                     deck: coding_basics,
                     account: seven
                   })

ViewedDeck.create!({
                     user: employee,
                     deck: hr_policies,
                     account: tech_corp
                   })

puts 'Creating deck share sessions...'
# Create deck share sessions
DeckShareSession.create!({
                           deck: marketing_basics,
                           user: dev,
                           owner_user: jimmy,
                           active: true
                         })

DeckShareSession.create!({
                           deck: coding_basics,
                           user: hilda,
                           owner_user: ceo,
                           active: true
                         })

puts 'Creating featured decks users...'
# Create featured decks users
FeaturedDecksUser.create!({
                            user: hilda,
                            deck: marketing_basics
                          })

FeaturedDecksUser.create!({
                            user: dev,
                            deck: coding_basics
                          })

puts 'Seed data created successfully!'
