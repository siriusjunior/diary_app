Faker::Config.locale = :en

comments = Comment.all
puts 'Start inserting seed "comment_likes" ...'

User.limit(13).each do |user|
    comments.sample(3).each do |comment|
        user.comment_like(comment)
    end
    puts "Comment_likes of #{user.username} has been created!"
end