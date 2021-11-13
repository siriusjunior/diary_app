# == Schema Information
#
# Table name: users
#
#  id                                  :bigint           not null, primary key
#  access_count_to_reset_password_page :integer          default(0)
#  activation_state                    :string(255)
#  activation_token                    :string(255)
#  activation_token_expires_at         :datetime
#  avatar                              :string(255)
#  crypted_password                    :string(255)
#  diary_date                          :integer          default(1), not null
#  email                               :string(255)      not null
#  introduction                        :text(65535)
#  remember_me_token                   :string(255)
#  remember_me_token_expires_at        :datetime
#  reset_password_email_sent_at        :datetime
#  reset_password_token                :string(255)
#  reset_password_token_expires_at     :datetime
#  salt                                :string(255)
#  username                            :string(255)      not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#
# Indexes
#
#  index_users_on_activation_token      (activation_token)
#  index_users_on_email                 (email) UNIQUE
#  index_users_on_remember_me_token     (remember_me_token)
#  index_users_on_reset_password_token  (reset_password_token)
#
class User < ApplicationRecord
  authenticates_with_sorcery!
  attr_accessor :skip_password

  validates :username, presence: true
  validates :email, uniqueness: true, presence: true
  validates :password, length: { minimum: 8 }, unless: :skip_password
  validates :password, confirmation: true, unless: :skip_password
  validates :password_confirmation, presence: true, unless: :skip_password
  validates :diary_date, presence: true
  validates :introduction, length: { maximum: 150 }
  mount_uploader :avatar, AvatarUploader
  
  has_many :diaries, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes
  has_many :like_diaries, through: :likes, source: :diary
  has_many :comment_likes
  has_many :like_comments, through: :comment_likes, source: :comment
  has_many :active_relationships, class_name: 'Relationship',
    foreign_key: 'follower_id',
    dependent: :destroy
  has_many :passive_relationships, class_name: 'Relationship',
    foreign_key: 'followed_id',
    dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :tag_links, dependen: :destroy
  has_many :tags, -> { order(:value) }, through: :tag_links

  def own?(object)
    id == object.user_id
  end
  
  def reset_diary
    update(diary_date: 1)
  end

  def like(diary)
    like_diaries << diary
  end

  def unlike(diary)
    like_diaries.destroy(diary)
  end

  def like?(diary)
    like_diaries.include?(diary)
  end

  def comment_like(comment)
    like_comments << comment
  end

  def comment_unlike(comment)
    like_comments.destroy(comment)
  end
  
  def comment_like?(comment)
    like_comments.include?(comment)
  end

  def follow(other_user)
    following << other_user
  end
  
  def unfollow(other_user)
    following.destroy(other_user)
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def feed
    Diary.where(user_id: following_ids << id)
  end

end
