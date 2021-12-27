Faker::Config.locale = :en

diaries = Diary.all
puts 'Start inserting seed "likes" ...'

User.limit(13).each do |user|
    diaries.sample(10).each do |diary|
        user.like(diary)
    end
end

puts "Diary likes created!"