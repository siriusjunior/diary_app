puts 'Start inserting first seed "user" ...'
first_user = User.create(
    email: 'foobar@gmail.com',
    username: 'foobar',
    password: 'password',
    password_confirmation: 'password',
    activation_state: "active"
)
puts "\"#{first_user.username}\" has been created!"

puts 'Start inserting seed "users" ...'
20.times do
    user = User.create(
        email: Faker::Internet.unique.email,
        username: Faker::Name.name,
        password: 'password',
        password_confirmation: 'password'
    )
    user.skip_password = true
    user.update!(activation_state: "active")
    puts "\"#{user.username}\" has been created!"
end