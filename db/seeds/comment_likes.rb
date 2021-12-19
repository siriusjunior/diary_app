Faker::Config.locale = :en

comments = Comment.all
puts 'Start inserting seed "comment_likes" ...'

User.limit(20).each do |user|
    comments.sample(150).each do |comment|
        user.comment_like(comment)
    end
end
puts "Comment_likes have been created!"