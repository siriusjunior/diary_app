Faker::Config.locale = :en
puts 'Start inserting seed "diaries" ...'
User.limit(13).each do |user|
    diary = user.diaries.create(
        body: Faker::Lorem.paragraph(sentence_count: 8, supplemental: false, random_sentences_to_add: 5),
        date_sequence: 1,
        remote_image_url: "https://picsum.photos/700/700/?random",
        check: Faker::Lorem.paragraph(sentence_count: 3, supplemental: false, random_sentences_to_add: 3)
    )
    puts "day1 diary#{diary.id} has created!"
    diary = user.diaries.create(
        body: Faker::Lorem.paragraph(sentence_count: 8, supplemental: false, random_sentences_to_add: 5),
        date_sequence: 2,
        remote_image_url: "https://picsum.photos/700/700/?random",
        check: Faker::Lorem.paragraph(sentence_count: 3, supplemental: false, random_sentences_to_add: 3)
    )
    puts "day2 diary#{diary.id} has created!"
end