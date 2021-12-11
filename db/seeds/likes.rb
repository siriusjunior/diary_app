Faker::Config.locale = :en

diaries = Diary.all
puts 'Start inserting seed "likes" ...'

User.limit(13).each do |user|
    diaries.sample(3).each do |diary|
        user.like(diary)
    end
    puts "Diary likes of #{user.username} has been created!"
end