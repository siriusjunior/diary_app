# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require './db/seeds/users'
require './db/seeds/diaries'
require './db/seeds/comments'
require './db/seeds/tags'
require './db/seeds/likes'
require './db/seeds/comment_likes'
require './db/seeds/plans'
require './db/seeds/chatrooms'