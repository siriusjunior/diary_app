# == Schema Information
#
# Table name: chatrooms
#
#  id         :bigint           not null, primary key
#  name       :string(255)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Chatroom < ApplicationRecord
    has_many :chatroom_users, dependent: :destroy
    has_many :users, through: :chatroom_users
    has_many :messages, dependent: :destroy
end
