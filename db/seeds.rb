User.destroy_all
Deck.destroy_all
Account.destroy_all
Card.destroy_all
DecksFolder.destroy_all
Department.destroy_all
Folder.destroy_all
Result.destroy_all
DeckSession.destroy_all

Account.create!(name: Faker::Company.name)
User.create!(name: Faker::Name.name, email: Faker::Internet.email, account: Account.first, password: 'passwords')
User.create!(name: Faker::Name.name, email: Faker::Internet.email, password: 'TestBeTesting')

Deck.create!(name: Faker::Lorem.sentence, description: Faker::Lorem.sentence, user: User.last)
Deck.create!(name: Faker::Lorem.sentence, description: Faker::Lorem.sentence, account: Account.first, user: User.first)

3.times do
  Card.create!(name: Faker::Lorem.sentence, title: Faker::Lorem.sentence, description: Faker::Lorem.sentence,
               deck: Deck.first, choices: [{ name: 'Test Choice', correct: true }])

  Card.create!(name: Faker::Lorem.sentence, title: Faker::Lorem.sentence, description: Faker::Lorem.sentence,
               deck: Deck.last, choices: [{ name: 'Test Choice', correct: true }])
end

Folder.create!(name: Faker::Lorem.sentence, user: User.first)

Deck.find_each do |deck|
  deck.update!(folder: Folder.first)
end
