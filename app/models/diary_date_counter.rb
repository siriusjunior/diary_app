# == Schema Information
#
# Table name: diary_date_counters
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  diary_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_diary_date_counters_on_diary_id  (diary_id)
#  index_diary_date_counters_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (diary_id => diaries.id)
#  fk_rails_...  (user_id => users.id)
#
class DiaryDateCounter < ApplicationRecord
  belongs_to :diary
  belongs_to :user
end
