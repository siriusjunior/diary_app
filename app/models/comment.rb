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
end
