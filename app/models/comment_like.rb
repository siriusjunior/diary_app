# == Schema Information
#
# Table name: comment_likes
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  comment_id :bigint
#  user_id    :bigint
#
# Indexes
#
#  index_comment_likes_on_comment_id              (comment_id)
#  index_comment_likes_on_user_id                 (user_id)
#  index_comment_likes_on_user_id_and_comment_id  (user_id,comment_id) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (comment_id => comments.id)
#  fk_rails_...  (user_id => users.id)
#
class CommentLike < ApplicationRecord
  belongs_to :user
  belongs_to :comment
  has_one :activity, as: :subject, dependent: :destroy

  validates :user_id, uniqueness: { scope: :comment_id }

  after_create_commit :create_activities

  private

    def create_activities
      Activity.create(subject: self, user: comment.user, action_type: :liked_to_own_comment)
      # 要調整/コメントいいねがコメントユーザーと等しいときは除外
      # if !user = comment.user
      #   Activity.create(subject: self, user: comment.user, action_type: :liked_to_own_comment)
      # end
    end
end
