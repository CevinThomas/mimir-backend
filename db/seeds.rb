Account.create!({ name: 'Maia', email: '@maiamarketing.se', allow_whitelist: true })
Account.create!({ name: '7 Software solutions', email: '@gmail.com', allow_whitelist: true })

User.create!({ name: 'Jimmy Bjornhard', email: 'jimmy.bjornhard@maiamarketing.se', password: 'password', account_id:
  Account.first.id,
               role: 'admin',
               confirmed_at: Time.current })
User.create!({ name: 'Hilda', email: 'hilda@maiamarketing.se', password: 'password', account_id: Account.first.id,
               confirmed_at: Time.current })
User.create!({ name: 'CEO of 7 Software solutions', email: 'ceo@gmail.com', password: 'password',
               account_id: Account.last.id, role: 'admin', confirmed_at: Time.current })
