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
  validates :body, presence: true, length: { maximum: 1000 }
  validates :date_sequence, presence: true
  mount_uploader :image, DiaryImageUploader
  before_create :register_date_sequence

  def user_diary_date
    self.user.diary_date
  end

  def increment_diary_date
    self.user.increment!(:diary_date)
  end
  
  private
  
    def register_date_sequence
      self.date_sequence = user_diary_date
    end

end
