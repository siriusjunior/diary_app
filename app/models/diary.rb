# == Schema Information
#
# Table name: diaries
#
#  id                    :bigint           not null, primary key
#  body                  :text(65535)      not null
#  check                 :text(65535)
#  comment_authorization :boolean          default(TRUE), not null
#  date_sequence         :integer          not null
#  image                 :string(255)
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  user_id               :bigint
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
  validates :body, presence: true, length: { maximum: 500 }
  validates :check, length: { maximum: 200 }
  validates :date_sequence, presence: true
  mount_uploader :image, DiaryImageUploader
  before_create :register_date_sequence

  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user

  scope :body_contain, ->(word){ where('diaries.body LIKE ?', "%#{word}%") }
  scope :thumbnail, -> { where.not(image: nil).order(created_at: :desc).limit(10) }
  scope :recent, ->(count) { order(created_at: :desc).limit(count)}

  def user_diary_date
    self.user.diary_date
  end

  def increment_diary_date
    self.user.increment!(:diary_date)
  end
  
  def register_date_sequence
    self.date_sequence = user_diary_date
  end

  # def self.sort(term)
  #   case term
  #     when 'new'
  #       return all.order(created_at: :DESC)
  #     when 'old'
  #       return all.order(created_at: :ASC)
  #     when 'likes'
  #       self.order_by_likes_count('desc')
  #     when 'dislikes'
  #       self.order_by_likes_count('asc')
  #   end
  # end

  # def self.order_by_likes_count(order)
  #   select("*, COUNT(diaries.id) AS likes_count") 
  #     .left_joins(:likes)
  #     .group("diaries.id")
  #     .order(:likes_count => order)
  # end
  
end
