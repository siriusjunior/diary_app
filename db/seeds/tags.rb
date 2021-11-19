names = %w(山東料理 四川料理 広東料理 江蘇料理 福建料理 浙江料理 湖南料理 安徽料理 魯菜 川菜 粤菜 蘇菜 閩菜 浙菜 徽菜)
puts 'Start inserting seed "tags" ...'
    names.map do |name|
        Tag.create!(name: name)
        puts "Tag whose name \"#{name}\" has been created!"
    end
tags = Tag.all

puts 'Start inserting seed "tag_links" ...'
User.all.each do |u|
    tags.sample(5).each do |tag|
        TagLink.create!(user: u, tag: tag)
        puts "TagLink whose username \"#{u.username}\", whose tagname \"#{tag.name}\" has been created!"
    end
end