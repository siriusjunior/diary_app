Faker::Config.locale = :en

diaries = Diary.all
users = User.all

puts 'Start inserting seed "comments of diaries " ...'

diaries.each do |diary|
    puts "Start inserting seed comments of diary-#{diary.id} ..."
    users.limit(rand(10)).each do |user|
        diary.comments.create!(user: user, body: Faker::Lorem.paragraph(sentence_count: 1, supplemental: false, random_sentences_to_add: 3))
    end
end
puts "Comments of each diaries has been created!"