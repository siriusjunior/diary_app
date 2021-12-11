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
FactoryBot.define do
  factory :user do
    email { Faker::Internet.unique.email }
    password { '12345678' }
    password_confirmation { '12345678' }
    username { Faker::Name.name }
    after(:create) do |user|
      user.skip_password = true
      user.update!(activation_state: "active")
    end

    trait :user_with_tag do
      after(:create) do |user|
        tag = create(:tag, name: "タグ1") unless Tag.find_by(name: "タグ1")
        create(:tag_link, user: user , tag: tag)
      end
    end

    trait :user_with_3_tags do
      after(:create) do |user|
        (1..3).each do |n|
          # 1~3登録
          tag = Tag.find_by(name: "タグ#{n}")
          if tag
            create(:tag_link, user: user , tag: tag)
          else
            new_tag = create(:tag, name: "タグ#{n}")
            create(:tag_link, user: user , tag: new_tag)
          end
        end
      end
    end
    
    trait :user_with_5_tags do
      after(:create) do |user|
        (1..5).each do |n|
          # 1~5登録
          tag = Tag.find_by(name: "タグ#{n}")
          if tag
            create(:tag_link, user: user , tag: tag)
          else
            new_tag = create(:tag, name: "タグ#{n}")
            create(:tag_link, user: user , tag: new_tag)
          end
        end
      end
    end

  end
end
