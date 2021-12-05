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
FactoryBot.define do
  factory :diary do
    body { Faker::Hacker.say_something_smart }
    image { File.open("#{Rails.root}/spec/fixtures/dummy.png") }
    date_sequence { 1 }
    user
  end
end
