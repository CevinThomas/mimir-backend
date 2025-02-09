Account.create!({ name: 'Maia' })

User.create!({ name: 'Jimmy Bjornhard', email: 'jimmy.bjornhard@maiamarketing.se', password: 'password', account_id: Account.last.id,
               role: 'admin',
               confirmed_at: Time.current })
User.create!({ name: 'Hilda', email: 'hilda@maiamarketing.se', password: 'password', account_id: Account.last.id,
               confirmed_at: Time.current })
