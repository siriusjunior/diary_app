Faker::Config.locale = :en

comments = Comment.all
users = User.all
puts 'Start inserting seed "comment_likes" ...'

users.each do |user|
    comments.sample(150).each do |comment|
        user.comment_like(comment)
    end
end
puts "Comment_likes created!"