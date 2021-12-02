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
