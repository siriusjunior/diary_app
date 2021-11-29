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
  end
end
