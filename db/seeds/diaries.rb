Faker::Config.locale = :en

users = User.all
puts 'Start inserting seed "diaries" ...'

users.each do |user|
    diary1 = user.diaries.create(
        body: Faker::Lorem.paragraph(sentence_count: 8, supplemental: false, random_sentences_to_add: 5),
        date_sequence: 1,
        remote_image_url: "https://picsum.photos/700/700/?random",
        check: Faker::Lorem.paragraph(sentence_count: 3, supplemental: false, random_sentences_to_add: 3)
    )
    puts "Day1 diary of \"#{user.username}\" has been created!"
    diary2 = user.diaries.create(
        body: Faker::Lorem.paragraph(sentence_count: 8, supplemental: false, random_sentences_to_add: 5),
        date_sequence: 2,
        remote_image_url: "https://picsum.photos/700/700/?random",
        check: Faker::Lorem.paragraph(sentence_count: 3, supplemental: false, random_sentences_to_add: 3)
    )
    puts "Day2 diary of \"#{user.username}\" has been created!"

    puts 'Start inserting seed "comments of Day1 diary" ...'
        users.sample(5).each do |user|
            diary1.comments.create!(user: user, body: Faker::Lorem.paragraph(sentence_count: 1, supplemental: false, random_sentences_to_add: 3))
        end
        puts "Comments of Day1 diary has been created!"
    puts 'Start inserting seed "comments of Day2 diary" ...'
        users.sample(5).each do |user|
            diary2.comments.create!(user: user, body: Faker::Lorem.paragraph(sentence_count: 1, supplemental: false, random_sentences_to_add: 3))
        end
        puts "Comments of Day2 diary has been created!"
end

