# == Schema Information
#
# Table name: activities
#
#  id           :bigint           not null, primary key
#  action_type  :integer          not null
#  read         :boolean          default(FALSE), not null
#  subject_type :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  subject_id   :bigint
#  user_id      :bigint
#
# Indexes
#
#  index_activities_on_subject_type_and_subject_id  (subject_type,subject_id)
#  index_activities_on_user_id                      (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Activity < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :subject, polymorphic: true
  belongs_to :user

  scope :recent, ->(count){ order(created_at: :desc).limit(count) }

  enum action_type: { commented_to_own_diary: 0, liked_to_own_diary: 1, followed_me: 2, liked_to_own_comment: 4 }
  enum read: { unread: false, read: true }

  def redirect_path
    case action_type.to_sym
      when :commented_to_own_diary
        diary_path(subject.diary, anchor: "comment-#{ subject.id }")
      when :liked_to_own_diary
        diary_path(subject.diary)
      when :followed_me
        user_path(subject.follower)
      when :liked_to_own_comment
        diary_path(subject.comment.diary, anchor: "comment-#{ subject.comment.id }")
    end
  end
end