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

    def self.chatroom_with_users(users)
        # [3,6]
        user_ids = users.map(&:id).sort
        name = user_ids.join(':').to_s

        unless (chatroom = find_by(name: name))
            chatroom = new(name: name)
            users.each do |user|
                user.skip_password = true
            end
            # ここでsorceryのuserpasswordバリデーションがかかるのでカバー
            chatroom.users = users
            chatroom.save
        end
        chatroom
    end

    def users_excluding(user)
        users.reject { |u| u == user }
    end

end
