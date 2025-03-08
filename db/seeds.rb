maia = Account.create!({ name: 'Maia', email: '@maiamarketing.se', allow_whitelist: true })
maia.folders.create(name: 'Uncategorized')
seven = Account.create!({ name: '7 Software solutions', email: '@gmail.com', allow_whitelist: true })

User.create!({ name: 'Jimmy Bjornhard', email: 'jimmy.bjornhard@maiamarketing.se', password: 'password', account_id:
  maia.id,
               role: 'admin',
               confirmed_at: Time.current })
User.create!({ name: 'Hilda', email: 'hilda@maiamarketing.se', password: 'password', account_id: maia.id,
               confirmed_at: Time.current })
User.create!({ name: 'CEO of 7 Software solutions', email: 'ceo@gmail.com', password: 'password',
               account_id: seven.id, role: 'admin', confirmed_at: Time.current })
