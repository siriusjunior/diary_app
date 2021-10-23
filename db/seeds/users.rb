puts 'Start inserting seed "users" ...'
10.times do
    user = User.create(
        email: Faker::Internet.unique.email,
        username: Faker::Name.name,
        password: 'password',
        password_confirmation: 'password',
        activation_state: "active"
    )
    puts "\"#{user.username}\" has created!"
end