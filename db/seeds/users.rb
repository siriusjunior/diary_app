puts 'Start inserting first seed "user" ...'
    first_user = User.create(
        email: 'foobar@gmail.com',
        username: 'foobar',
        password: 'password',
        password_confirmation: 'password',
        activation_state: "active",
        avatar: open("./db/fixtures/foobar.png")
    )
puts "\"#{ first_user.username }\" has been created!"

puts 'Start inserting first seed "gest" ...'
    password = SecureRandom.urlsafe_base64.slice(1..8).downcase
    guest = User.create(
        email: 'guest@example.com',
        username: 'ゲストユーザー',
        password: password,
        password_confirmation: password,
        activation_state: 'active',
        introduction: 'ゲストユーザーの自己紹介です。',
        avatar: open("./db/fixtures/guest.png")
    )
    guest.skip_password = true
    guest.update!(activation_state: "active")
puts "\"#{ guest.username }\" has been created!"

20.times do
    user = User.create(
        email: Faker::Internet.unique.email,
        username: Faker::Name.name,
        password: 'password',
        password_confirmation: 'password',
        remote_avatar_url: "https://i.pravatar.cc/200"
    )
    user.skip_password = true
    user.update!(activation_state: "active")
    puts "\"#{ user.username }\" has been created!"
end

puts "Start creating some relationships about \"#{ guest.username }\""
users = User.all
following = users[11..20]
followers = users[3..10]
following.each { |followed| guest.follow(followed) }
followers.each { |follower| follower.follow(guest) }
puts "Created some relationships about \"#{ guest.username }\""