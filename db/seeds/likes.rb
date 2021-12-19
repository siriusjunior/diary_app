Faker::Config.locale = :en

diaries = Diary.all
puts 'Start inserting seed "likes" ...'

User.limit(17).each do |user|
    diaries.sample(30).each do |diary|
        user.like(diary)
    end
end

puts "Diary likes have been created!"