# == Schema Information
#
# Table name: diary_resets
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint
#
# Indexes
#
#  index_diary_resets_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class DiaryReset < ApplicationRecord
  belongs_to :user
end
