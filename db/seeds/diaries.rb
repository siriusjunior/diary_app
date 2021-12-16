Faker::Config.locale = :en

guest = User.find_by(email: 'guest@example.com')
users = User.all.reject { |user| user == guest}

puts 'Start inserting seed guest_user "diaries" ...'
(1..5).each do |n|
    guest.diaries.create!(
        body: Faker::Lorem.paragraph(sentence_count: 8, supplemental: false, random_sentences_to_add: 5),
        date_sequence: n,
        remote_image_url: "https://picsum.photos/700/700/?random",
        check: Faker::Lorem.paragraph(sentence_count: 3, supplemental: false, random_sentences_to_add: 3),
        created_at: Time.current.ago(7.days)
    )
end
puts 'guest_user "diaries" have been created!'

puts 'Start inserting seed "diaries" ...'
users.each do |user|
    diary1 = user.diaries.create!(
        body: Faker::Lorem.paragraph(sentence_count: 8, supplemental: false, random_sentences_to_add: 5),
        date_sequence: 1,
        remote_image_url: "https://picsum.photos/700/700/?random",
        check: Faker::Lorem.paragraph(sentence_count: 3, supplemental: false, random_sentences_to_add: 3)
    )
    puts "Day1 diary of \"#{user.username}\" has been created!"
    diary2 = user.diaries.create!(
        body: Faker::Lorem.paragraph(sentence_count: 8, supplemental: false, random_sentences_to_add: 5),
        date_sequence: 2,
        remote_image_url: "https://picsum.photos/700/700/?random",
        check: Faker::Lorem.paragraph(sentence_count: 3, supplemental: false, random_sentences_to_add: 3)
    )
    puts "Day2 diary of \"#{user.username}\" has been created!"
end

