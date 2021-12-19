# == Schema Information
#
# Table name: comments
#
#  id         :bigint           not null, primary key
#  body       :text(65535)      not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  diary_id   :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comments_on_diary_id  (diary_id)
#  index_comments_on_user_id   (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (diary_id => diaries.id)
#  fk_rails_...  (user_id => users.id)
#
class Comment < ApplicationRecord
  belongs_to :diary
  belongs_to :user
  has_many :comment_likes, dependent: :destroy
  has_many :comment_like_users, through: :comment_likes, source: :user
  has_one :activity, as: :subject, dependent: :destroy

  validates :body, presence: true, length: { maximum: 300 }

  after_create_commit :create_activities

  def liked_by_owner?
    owner_like =  comment_likes.find_by(user_id: diary.user_id)
    comment_likes.include?(owner_like)
  end

  private

    def create_activities
      # コメントがダイアリーユーザーと等しいときは除外
      if user_id != diary.user_id
        Activity.create(subject: self, user: diary.user, action_type: :commented_to_own_diary)
      end
    end
end
