puts 'Start inserting seed "diaries" ...'
User.limit(10).each do |user|
    diary = user.diaries.create({ body: Faker::Hacker.say_something_smart })
    puts "diary#{diary.id} has created!"
end