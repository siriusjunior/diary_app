names = %w(ロック リズム ビート レゲエ オペラ ジャズ ヘビメタ フォーク ダンス カントリー クラシック ブルース ギター ドラム ピアノ バイオリン サックス ビオラ ハウス ラウンジ ディープ R&B)
puts 'Start inserting seed "tags" ...'
    names.map do |name|
        Tag.create!(name: name)
    end
puts "Tags created!"

tags = Tag.all
puts 'Start inserting seed "tag_links" ...'
User.all.each do |u|
    tags.sample(5).each do |tag|
        TagLink.create!(user: u, tag: tag)
    end
end
puts "TagLinks created!"