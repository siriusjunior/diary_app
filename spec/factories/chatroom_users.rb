# == Schema Information
#
# Table name: chatroom_users
#
#  id           :bigint           not null, primary key
#  datetime     :datetime
#  last_read_at :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  chatroom_id  :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_chatroom_users_on_chatroom_id  (chatroom_id)
#  index_chatroom_users_on_user_id      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (chatroom_id => chatrooms.id)
#  fk_rails_...  (user_id => users.id)
#
FactoryBot.define do
  factory :chatroom_user do
    user { nil }
    chatroom { nil }
    last_read_at { "2021-12-06 05:21:33" }
  end
end