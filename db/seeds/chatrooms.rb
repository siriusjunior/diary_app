Faker::Config.locale = :en

puts 'Start inserting "chatroom" regarding guest_user ...'

user = User.find_by(email: 'guest@example.com')
invited = user.following.last

chatroom = Chatroom.chatroom_with_users([user] + [invited])

user.messages.create!(body: 'こんにちは、今日はいい天気だね。', user: user, chatroom: chatroom)
invited.messages.create!(body: 'メッセージありがとう。天気いいよね。どこかにドライブでもしたい。', user: user, chatroom: chatroom)
user.messages.create!(body: 'ドライブいいね。旅行するとしたら、県内の旅行がいいな。', user: user, chatroom: chatroom)
invited.messages.create!(body: 'そうだな。どっこも行ってないし今日暇だし、どっか行ってみる？', user: user, chatroom: chatroom)

puts 'Created chatroom with some messages!'

