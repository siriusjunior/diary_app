names = %w(ロック リズム ビート レゲエ オペラ ジャズ ヘビメタ フォーク ダンス カントリー クラシック ブルース ギター ドラム ピアノ バイオリン サックス ビオラ)
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