# == Schema Information
#
# Table name: likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  diary_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_likes_on_diary_id              (diary_id)
#  index_likes_on_user_id               (user_id)
#  index_likes_on_user_id_and_diary_id  (user_id,diary_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (diary_id => diaries.id)
#  fk_rails_...  (user_id => users.id)
#
class Like < ApplicationRecord
  belongs_to :user
  belongs_to :diary
  has_one :activity, as: :subject, dependent: :destroy

  validates :user_id, uniqueness: { scope: :diary_id }

  after_create_commit :create_activities

  private

    def create_activities
      # いいねがダイアリーユーザーと等しいときは除外
      if user_id != diary.user_id
        Activity.create(subject: self, user: diary.user, action_type: :liked_to_own_diary)
      end
    end
end
