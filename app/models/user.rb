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
#  notification_on_comment             :boolean          default(TRUE)
#  notification_on_comment_like        :boolean          default(TRUE)
#  notification_on_follow              :boolean          default(TRUE)
#  notification_on_like                :boolean          default(TRUE)
#  remember_me_token                   :string(255)
#  remember_me_token_expires_at        :datetime
#  reset_password_email_sent_at        :datetime
#  reset_password_token                :string(255)
#  reset_password_token_expires_at     :datetime
#  salt                                :string(255)
#  username                            :string(255)      not null
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  customer_id                         :string(255)
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
  include PayjpCustomer
  attr_accessor :skip_password

  validates :username, presence: true, length: { maximum: 8 }
  validates :email, uniqueness: true, presence: true, length: { maximum: 45 }
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
  has_many :tag_links, dependent: :destroy
  has_many :tags, -> { order(:name) }, through: :tag_links
  has_many :activities, dependent: :destroy
  has_many :chatroom_users, dependent: :destroy
  has_many :chatrooms, through: :chatroom_users
  has_many :messages, dependent: :destroy

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

  def have_following?
    following_ids.any?
  end

  def feed
    Diary.where(user_id: following_ids << id)
  end

  def self_feed
    Diary.where(user_id: id)
  end

  def add_tag!(labels)
    # ?????????labels???????????????(ex:labels=["A","B","C","F","G"], current_labels=["A","B","C","D","E"])
    current_labels = self.tags.pluck(:name) unless self.tags.nil?
    # ????????????????????????????????????????????????(ex:old_labels=["D","E"])
    old_labels = current_labels - labels
    # ?????????????????????????????????????????????????????????????????????(ex:new_labels=["F","G"])
    new_labels = labels - current_labels
    # ?????????????????????
    self.class.transaction do
      new_labels.each do |new_label|
        break if new_label.blank?
        tag = Tag.find_by(name: new_label) 
        tag ||= Tag.create!(name: new_label)
        # ???????????????tag_link????????????????????????
        unless tag_links.where(tag_id: tag.id).exists?
          #???????????????user_id?????????
          tag_links.create!(tag_id: tag.id)
        end
      end
    end
    # ???????????????????????????
    self.class.transaction do
      old_labels.each do |old_label|
        tag = Tag.find_by(name: old_label)
        if tag
          #?????????????????????user_id?????????
          tag_links.find_by(tag_id: tag.id).destroy
          # tag????????????tag_link?????????????????????????????????
          if tag.tag_links.empty?
            tag.destroy
          end
        end
      end
    end
  end

  def latest_diary
    diaries.order(created_at: :desc).limit(1)
  end
  
  def cannot_post?
    if diaries.any?
      latest_diary = diaries.order(created_at: :desc).limit(1)
      #????????????????????????????????????????????????1????????????????????????????????????true
      (Time.zone.now - latest_diary.first.created_at) < 1.day
    else
      return false
    end
  end

  def has_room_with?(other)
    users = [self] + [other]
    user_ids = users.map(&:id).sort
    room_name = user_ids.join(':').to_s
    Chatroom.find_by(name: room_name).present?
  end

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.username = '?????????????????????'
      user.password = SecureRandom.urlsafe_base64.slice(1..8).downcase
      user.password_confirmation = user.password
      user.introduction = '?????????????????????????????????????????????'
    end
  end
  
end
