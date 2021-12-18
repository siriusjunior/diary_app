Faker::Config.locale = :en

comments = Comment.all
puts 'Start inserting seed "comment_likes" ...'

User.limit(18).each do |user|
    comments.sample(10).each do |comment|
        user.comment_like(comment)
    end
end
puts "Comment_likes have been created!"