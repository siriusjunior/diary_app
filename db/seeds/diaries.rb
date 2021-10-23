Faker::Config.locale = :en
puts 'Start inserting seed "diaries" ...'
User.limit(10).each do |user|
    diary = user.diaries.create(
        body: Faker::Lorem.paragraph(sentence_count: 15, supplemental: false, random_sentences_to_add: 13),
        date_sequence: 1
    )
    puts "diary#{diary.id} has created!"
end