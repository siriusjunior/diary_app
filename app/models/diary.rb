# == Schema Information
#
# Table name: diaries
#
#  id            :bigint           not null, primary key
#  body          :text(65535)      not null
#  check         :text(65535)
#  date_sequence :integer          default(1), not null
#  image         :string(255)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Indexes
#
#  index_diaries_on_user_id  (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Diary < ApplicationRecord
  belongs_to :user
  has_one :diary_date_counter
  validates :body, presence: true, length: { maximum: 1000 }
  mount_uploader :image, DiaryImageUploader
end
